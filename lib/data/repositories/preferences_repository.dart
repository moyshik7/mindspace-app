import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class PreferencesRepository {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ─── Onboarding ──────────────────────────────────────────
  Future<bool> isOnboardingComplete() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyOnboardingComplete) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final p = await prefs;
    await p.setBool(AppConstants.keyOnboardingComplete, true);
  }

  // ─── Auth ──────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final p = await prefs;
    await p.setBool(AppConstants.keyIsLoggedIn, value);
  }

  Future<void> setUserName(String name) async {
    final p = await prefs;
    await p.setString(AppConstants.keyUserName, name);
  }

  Future<String> getUserName() async {
    final p = await prefs;
    return p.getString(AppConstants.keyUserName) ?? 'User';
  }

  Future<void> setUserEmail(String email) async {
    final p = await prefs;
    await p.setString(AppConstants.keyUserEmail, email);
  }

  Future<String> getUserEmail() async {
    final p = await prefs;
    return p.getString(AppConstants.keyUserEmail) ?? '';
  }

  // ─── Streak ──────────────────────────────────────────
  Future<int> getStreakCount() async {
    final p = await prefs;
    return p.getInt(AppConstants.keyStreakCount) ?? 1;
  }

  Future<void> setStreakCount(int count) async {
    final p = await prefs;
    await p.setInt(AppConstants.keyStreakCount, count);
  }

  Future<String?> getLastOpenDate() async {
    final p = await prefs;
    return p.getString(AppConstants.keyLastOpenDate);
  }

  Future<void> setLastOpenDate(String date) async {
    final p = await prefs;
    await p.setString(AppConstants.keyLastOpenDate, date);
  }

  // ─── Notifications ──────────────────────────────────────────
  Future<bool> getNotificationsEnabled() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final p = await prefs;
    await p.setBool(AppConstants.keyNotificationsEnabled, value);
  }

  Future<int> getReminderHour() async {
    final p = await prefs;
    return p.getInt(AppConstants.keyReminderHour) ?? 18; // Default 6 PM
  }

  Future<int> getReminderMinute() async {
    final p = await prefs;
    return p.getInt(AppConstants.keyReminderMinute) ?? 0;
  }

  Future<void> setReminderTime(int hour, int minute) async {
    final p = await prefs;
    await p.setInt(AppConstants.keyReminderHour, hour);
    await p.setInt(AppConstants.keyReminderMinute, minute);
  }

  // ─── Plan ──────────────────────────────────────────
  Future<String> getPlanType() async {
    final p = await prefs;
    return p.getString(AppConstants.keyPlanType) ?? 'free';
  }

  Future<void> setPlanType(String plan) async {
    final p = await prefs;
    await p.setString(AppConstants.keyPlanType, plan);
  }

  // ─── Clear All ──────────────────────────────────────────
  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }
}
