import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _keyName = 'user_name';
  static const _keyPhone = 'user_phone';
  static const _keyDob = 'user_dob';
  static const _keyProfileImage = 'profile_image_path';
  static const _keyIsLoggedIn = 'is_logged_in';

  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
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

  // Getters
  static String? getName() => prefs.getString(_keyName);
  static String? getPhone() => prefs.getString(_keyPhone);
  static String? getDob() => prefs.getString(_keyDob);
  static String? getProfileImagePath() => prefs.getString(_keyProfileImage);
  static bool isLoggedIn() => prefs.getBool(_keyIsLoggedIn) ?? false;

  // Clear all auth related prefs (used on logout)
  static Future<void> clearAuthData() async {
    await prefs.remove(_keyName);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyDob);
    await prefs.remove(_keyProfileImage);
    await prefs.remove(_keyIsLoggedIn);
  }
}
