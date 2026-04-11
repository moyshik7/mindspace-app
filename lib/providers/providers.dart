import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../data/models/post_model.dart';
import '../data/repositories/preferences_repository.dart';
import '../core/utils/date_utils.dart';
import '../services/notification_service.dart';

// ─── Preferences Repository Provider ──────────────────────────────
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});

// ─── Auth State ──────────────────────────────────────────
enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;
  final bool onboardingComplete;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
    this.onboardingComplete = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
    bool? onboardingComplete,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final PreferencesRepository _prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthNotifier(this._prefs) : super(const AuthState()) {
    _auth.authStateChanges().listen((User? user) async {
      try {
        final onboardingDone = await _prefs.isOnboardingComplete();
        if (user != null) {
          await _prefs.setUserName(user.displayName ?? 'User');
          await _prefs.setUserEmail(user.email ?? '');
          await _prefs.setLoggedIn(true);
          state = state.copyWith(
            status: AuthStatus.authenticated,
            onboardingComplete: onboardingDone,
          );
        } else {
          await _prefs.setLoggedIn(false);
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            onboardingComplete: onboardingDone,
          );
        }
      } catch (e) {
        debugPrint('Auth listener error: $e');
      }
    });
  }

  Future<void> checkAuthStatus() async {
    try {
      final onboardingDone = await _prefs.isOnboardingComplete();
      state = state.copyWith(onboardingComplete: onboardingDone);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await _auth.signInWithCredential(credential);
      await _prefs.setOnboardingComplete();
      state = state.copyWith(
        isLoading: false,
        onboardingComplete: true,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _prefs.setOnboardingComplete();
    state = state.copyWith(onboardingComplete: true);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _prefs.setLoggedIn(false);
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return AuthNotifier(prefs);
});

// ─── User State ──────────────────────────────────────────
class UserNotifier extends StateNotifier<UserModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _userSub;

  UserNotifier() : super(UserModel.demo) {
    FirebaseAuth.instance.authStateChanges().listen((fbUser) {
      _userSub?.cancel();
      if (fbUser != null) {
        _userSub = _firestore
            .collection('users')
            .doc(fbUser.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            final user = UserModel.fromJson(snapshot.data()!);
            state = user;
          } else {
            // Create user profile on first sign-in
            final newUser = UserModel(
              uid: fbUser.uid,
              name: fbUser.displayName ?? 'User',
              email: fbUser.email ?? '',
              photoUrl: fbUser.photoURL,
              createdAt: DateTime.now(),
            );
            _firestore.collection('users').doc(fbUser.uid).set(newUser.toJson());
          }
        });
      } else {
        state = UserModel.demo;
      }
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> loadUser() async {
    // Keep for backward compatibility, data relies on stream now.
  }

  void updatePlan(PlanType plan) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _firestore.collection('users').doc(uid).update({'planType': plan.name});
    } else {
      state = state.copyWith(planType: plan);
    }
  }

  Future<void> updateProfile({
    required String name,
    required String bio,
    required String description,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'bio': bio,
        'description': description,
      });
    } else {
      state = state.copyWith(name: name, bio: bio, description: description);
    }
  }

  void enrollCourse(String courseId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _firestore.collection('users').doc(uid).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId]),
        'courseProgress.$courseId': 0,
      });
    } else {
      if (!state.enrolledCourses.contains(courseId)) {
        final enrolled = List<String>.from(state.enrolledCourses)..add(courseId);
        final progress = Map<String, int>.from(state.courseProgress);
        progress[courseId] = 0;
        state = state.copyWith(
          enrolledCourses: enrolled,
          courseProgress: progress,
        );
      }
    }
  }

  void completeLesson(String courseId, int lessonIndex) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final lessonKey = '${courseId}_$lessonIndex';
    if (uid != null) {
      _firestore.collection('users').doc(uid).update({
        'completedLessons': FieldValue.arrayUnion([lessonKey]),
        'courseProgress.$courseId': FieldValue.increment(1),
      });
    } else {
      if (!state.completedLessons.contains(lessonKey)) {
        final completed = Set<String>.from(state.completedLessons)..add(lessonKey);
        final progress = Map<String, int>.from(state.courseProgress);
        progress[courseId] = (progress[courseId] ?? 0) + 1;
        state = state.copyWith(
          completedLessons: completed,
          courseProgress: progress,
        );
      }
    }
  }

  bool isLessonCompleted(String courseId, int lessonIndex) {
    return state.completedLessons.contains('${courseId}_$lessonIndex');
  }

  int getCourseProgress(String courseId) {
    return state.courseProgress[courseId] ?? 0;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

// ─── Streak ──────────────────────────────────────────
class StreakNotifier extends StateNotifier<int> {
  final PreferencesRepository _prefs;
  StreakNotifier(this._prefs) : super(1);

  Future<void> checkAndUpdateStreak() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) return;
      
      final data = doc.data()!;
      final lastDateStr = data['lastOpenDate'] as String?;
      final streakCount = data['streakCount'] as int? ?? 1;
      
      final today = DateTime.now();
      final todayStr = today.toIso8601String().substring(0, 10);
      final lastDateOnly = lastDateStr != null && lastDateStr.length >= 10 
          ? lastDateStr.substring(0, 10) 
          : null;
      
      if (lastDateOnly == null) {
        await docRef.update({'lastOpenDate': today.toIso8601String(), 'streakCount': 1});
        state = 1;
        final hour = await _prefs.getReminderHour();
        final minute = await _prefs.getReminderMinute();
        await NotificationService().scheduleStreakReminder(hour: hour, minute: minute);
        return;
      }
      
      if (lastDateOnly == todayStr) {
        state = streakCount;
        final hour = await _prefs.getReminderHour();
        final minute = await _prefs.getReminderMinute();
        await NotificationService().scheduleStreakReminder(hour: hour, minute: minute);
        return;
      }
      
      final lastDate = DateTime.parse(lastDateOnly);
      if (AppDateUtils.isConsecutiveDay(lastDate, today)) {
        final newStreak = streakCount + 1;
        await docRef.update({'lastOpenDate': today.toIso8601String(), 'streakCount': newStreak});
        state = newStreak;
      } else {
        await docRef.update({'lastOpenDate': today.toIso8601String(), 'streakCount': 1});
        state = 1;
      }
      
      final hour = await _prefs.getReminderHour();
      final minute = await _prefs.getReminderMinute();
      await NotificationService().scheduleStreakReminder(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('Streak update error: $e');
      state = 1;
    }
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, int>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return StreakNotifier(prefs);
});

// ─── Settings ──────────────────────────────────────────
class SettingsState {
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;

  SettingsState({
    required this.notificationsEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final PreferencesRepository _prefs;

  SettingsNotifier(this._prefs)
      : super(SettingsState(
          notificationsEnabled: true,
          reminderHour: 18,
          reminderMinute: 0,
        ));

  Future<void> loadNotificationSetting() async {
    final enabled = await _prefs.getNotificationsEnabled();
    final hour = await _prefs.getReminderHour();
    final minute = await _prefs.getReminderMinute();
    state = SettingsState(
      notificationsEnabled: enabled,
      reminderHour: hour,
      reminderMinute: minute,
    );
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _prefs.setNotificationsEnabled(value);
  }

  Future<void> setReminderTime(int hour, int minute) async {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    await _prefs.setReminderTime(hour, minute);
    
    // Reschedule reminder if enabled
    if (state.notificationsEnabled) {
      await NotificationService().scheduleStreakReminder(
        hour: hour,
        minute: minute,
      );
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return SettingsNotifier(prefs);
});

final otherUserProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (snapshot.exists && snapshot.data() != null) {
    return UserModel.fromJson(snapshot.data()!);
  }
  return null;
});
