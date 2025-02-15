import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/settings_profile/models/user_model.dart';

class UserViewModel with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.postData("/auth/get_current_user");
      if (response != null && response.data != null) {
        _user = UserModel.fromJson(response.data);
      }
    } catch (e) {
      log("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUserData() {
    _user = null;
    notifyListeners();
  }
}