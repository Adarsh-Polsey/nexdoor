import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/settings_profile/models/user_model.dart';

class UserViewModel with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postData("/auth/get_current_user");
      if (response != null && response.data != null) {
        _user = UserModel.fromJson(response.data);
      }
    } catch (e) {
      _errorMessage = "Error fetching user data: $e";
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile(UserModel updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postData(
        "/users/update_profile",
        data: updatedUser.toJson(),
      );

      if (response.statusCode == 200) {
        _user = updatedUser;
        return true;
      } else {
        _errorMessage = "Failed to update profile";
        return false;
      }
    } catch (e) {
      _errorMessage = "Error updating profile: $e";
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUserData() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}