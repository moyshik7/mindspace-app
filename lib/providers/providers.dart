import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/models/post_model.dart';
import '../data/repositories/preferences_repository.dart';
import '../core/utils/date_utils.dart';

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

  AuthNotifier(this._prefs) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _prefs.isLoggedIn();
      final onboardingDone = await _prefs.isOnboardingComplete();
      state = state.copyWith(
        status:
            isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        onboardingComplete: onboardingDone,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> signIn(String name, String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _prefs.setLoggedIn(true);
      await _prefs.setUserName(name);
      await _prefs.setUserEmail(email);
      await _prefs.setOnboardingComplete();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
        onboardingComplete: true,
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
    await _prefs.clearAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return AuthNotifier(prefs);
});

// ─── User State ──────────────────────────────────────────
class UserNotifier extends StateNotifier<UserModel> {
  final PreferencesRepository _prefs;

  UserNotifier(this._prefs) : super(UserModel.demo);

  Future<void> loadUser() async {
    try {
      final name = await _prefs.getUserName();
      final email = await _prefs.getUserEmail();
      final streak = await _prefs.getStreakCount();
      final planStr = await _prefs.getPlanType();
      final plan = PlanType.values.firstWhere(
        (e) => e.name == planStr,
        orElse: () => PlanType.free,
      );

      state = state.copyWith(
        name: name,
        email: email,
        streakCount: streak,
        planType: plan,
      );
    } catch (e) {
      // Keep demo state on error
    }
  }

  void updatePlan(PlanType plan) {
    state = state.copyWith(planType: plan);
    _prefs.setPlanType(plan.name);
  }

  void enrollCourse(String courseId) {
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

  void completeLesson(String courseId, int lessonIndex) {
    final lessonKey = '${courseId}_$lessonIndex';
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

  bool isLessonCompleted(String courseId, int lessonIndex) {
    return state.completedLessons.contains('${courseId}_$lessonIndex');
  }

  int getCourseProgress(String courseId) {
    return state.courseProgress[courseId] ?? 0;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return UserNotifier(prefs);
});

// ─── Streak ──────────────────────────────────────────
class StreakNotifier extends StateNotifier<int> {
  final PreferencesRepository _prefs;

  StreakNotifier(this._prefs) : super(1);

  Future<void> checkAndUpdateStreak() async {
    try {
      final lastDateStr = await _prefs.getLastOpenDate();
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      if (lastDateStr == null) {
        // First time
        await _prefs.setLastOpenDate(todayStr);
        await _prefs.setStreakCount(1);
        state = 1;
        return;
      }

      if (lastDateStr == todayStr) {
        // Same day, no change
        state = await _prefs.getStreakCount();
        return;
      }

      final lastDate = DateTime.parse(lastDateStr);
      if (AppDateUtils.isConsecutiveDay(lastDate, today)) {
        // Consecutive day — increment streak
        final newStreak = (await _prefs.getStreakCount()) + 1;
        await _prefs.setStreakCount(newStreak);
        await _prefs.setLastOpenDate(todayStr);
        state = newStreak;
      } else {
        // Missed a day — reset to 1
        await _prefs.setStreakCount(1);
        await _prefs.setLastOpenDate(todayStr);
        state = 1;
      }
    } catch (e) {
      state = 1;
    }
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, int>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return StreakNotifier(prefs);
});

// ─── Community (Likes) ──────────────────────────────────────────
class CommunityNotifier extends StateNotifier<List<PostModel>> {
  CommunityNotifier() : super([]);

  void toggleLike(String postId) {
    state = [
      for (final post in state)
        if (post.id == postId)
          PostModel(
            id: post.id,
            username: post.username,
            flair: post.flair,
            text: post.text,
            likes: post.isLiked ? post.likes - 1 : post.likes + 1,
            comments: post.comments,
            createdAt: post.createdAt,
            isLiked: !post.isLiked,
          )
        else
          post,
    ];
  }
}

// ─── Settings ──────────────────────────────────────────
class SettingsNotifier extends StateNotifier<bool> {
  final PreferencesRepository _prefs;

  SettingsNotifier(this._prefs) : super(true);

  Future<void> loadNotificationSetting() async {
    state = await _prefs.getNotificationsEnabled();
  }

  Future<void> toggleNotifications(bool value) async {
    state = value;
    await _prefs.setNotificationsEnabled(value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, bool>((ref) {
  final prefs = ref.read(preferencesRepositoryProvider);
  return SettingsNotifier(prefs);
});
