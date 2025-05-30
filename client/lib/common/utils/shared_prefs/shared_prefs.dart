import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    log("getUserId(): ${prefs.getString('userId')}");
    return prefs.getString('userId');
  }

  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}