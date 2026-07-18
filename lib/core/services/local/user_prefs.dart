import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _keyName = 'user_name';
  static const _keyPhone = 'user_phone';
  static const _keyDob = 'user_dob';
  static const _keyProfileImage = 'profile_image_path';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyIsDarkMode = 'is_dark_mode';
  static const _keyPin = 'user_pin';
  static const _keyFingerprintName = 'fingerprint_name';
  static const _keySeenOnboarding = 'seen_onboarding';

  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('fingerprint_name_initialized')) {
      await prefs.setString(_keyFingerprintName, 'John Fingerprint');
      await prefs.setBool('fingerprint_name_initialized', true);
    }
  }

  // Save name
  static Future<void> setName(String name) async {
    await prefs.setString(_keyName, name);
  }

  // Save phone
  static Future<void> setPhone(String phone) async {
    await prefs.setString(_keyPhone, phone);
  }

  // Save date of birth (ISO string)
  static Future<void> setDob(String isoDob) async {
    await prefs.setString(_keyDob, isoDob);
  }

  // Save profile image path
  static Future<void> setProfileImagePath(String path) async {
    await prefs.setString(_keyProfileImage, path);
  }

  // Save logged in state
  static Future<void> setIsLoggedIn(bool val) async {
    await prefs.setBool(_keyIsLoggedIn, val);
  }

  // Save dark mode state
  static Future<void> setIsDarkMode(bool val) async {
    await prefs.setBool(_keyIsDarkMode, val);
  }

  // Save PIN
  static Future<void> setPin(String pin) async {
    await prefs.setString(_keyPin, pin);
  }

  // Save Fingerprint Name
  static Future<void> setFingerprintName(String name) async {
    await prefs.setString(_keyFingerprintName, name);
  }

  // Get Fingerprint Name
  static String? getFingerprintName() => prefs.getString(_keyFingerprintName);

  // Delete Fingerprint Name
  static Future<void> deleteFingerprint() async {
    await prefs.remove(_keyFingerprintName);
  }

  // Get Onboarding State
  static bool getSeenOnboarding() => prefs.getBool(_keySeenOnboarding) ?? false;

  // Set Onboarding State
  static Future<void> setSeenOnboarding(bool val) async {
    await prefs.setBool(_keySeenOnboarding, val);
  }

  // Get Notification Setting
  static bool getNotifSetting(String key) => prefs.getBool(key) ?? true;

  // Set Notification Setting
  static Future<void> setNotifSetting(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  // Getters
  static String? getName() => prefs.getString(_keyName);
  static String? getPhone() => prefs.getString(_keyPhone);
  static String? getDob() => prefs.getString(_keyDob);
  static String? getProfileImagePath() => prefs.getString(_keyProfileImage);
  static bool isLoggedIn() => prefs.getBool(_keyIsLoggedIn) ?? false;
  static bool isDarkMode() => prefs.getBool(_keyIsDarkMode) ?? false;
  static String getPin() => prefs.getString(_keyPin) ?? '123456';

  // Clear all auth related prefs (used on logout)
  static Future<void> clearAuthData() async {
    await prefs.remove(_keyName);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyDob);
    await prefs.remove(_keyProfileImage);
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyPin);
    await prefs.remove(_keyFingerprintName);
    await prefs.remove('fingerprint_name_initialized');
    await prefs.remove(_keySeenOnboarding);
    await prefs.remove('notif_general');
    await prefs.remove('notif_sound');
    await prefs.remove('notif_sound_call');
    await prefs.remove('notif_vibrate');
    await prefs.remove('notif_transaction_update');
    await prefs.remove('notif_expense_reminder');
    await prefs.remove('notif_budget');
    await prefs.remove('notif_low_balance');
  }
}
