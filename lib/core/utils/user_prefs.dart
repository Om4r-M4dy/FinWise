import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _keyName = 'user_name';
  static const _keyPhone = 'user_phone';
  static const _keyDob = 'user_dob';
  static const _keyProfileImage = 'profile_image_path';

  // Save name
  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // Save phone
  static Future<void> setPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, phone);
  }

  // Save date of birth (ISO string)
  static Future<void> setDob(String isoDob) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDob, isoDob);
  }

  // Save profile image path
  static Future<void> setProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, path);
  }

  // Getters
  static Future<String?> getName() async => (await SharedPreferences.getInstance()).getString(_keyName);
  static Future<String?> getPhone() async => (await SharedPreferences.getInstance()).getString(_keyPhone);
  static Future<String?> getDob() async => (await SharedPreferences.getInstance()).getString(_keyDob);
  static Future<String?> getProfileImagePath() async => (await SharedPreferences.getInstance()).getString(_keyProfileImage);

  // Clear all auth related prefs (used on logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyDob);
    await prefs.remove(_keyProfileImage);
  }
}
