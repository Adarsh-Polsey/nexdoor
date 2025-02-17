import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/settings_profile/models/user_model.dart';

class ProfileViewModel with ChangeNotifier {
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

// Business profile retrieval

  final List<BusinessModel> _businesses = [];
  BusinessModel? _business; 
  String? _errorMessage;

  List<BusinessModel> get businesses => _businesses;
  BusinessModel? get business => _business;
  String? get errorMessage => _errorMessage;

  // Fetch a single business by ID
  Future<BusinessModel?> fetchABusiness({String? businessId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Response response = await _apiService.getData(
        '/businesses/get_business',
        queryParameters: businessId != null ? {'business_id': businessId} : {},
      );

      if (response.statusCode == 200) {
        _business = BusinessModel.fromJson(response.data);
        return _business;
      } else {
        throw Exception('No business data found');
      }
    } catch (e,s) {
      _errorMessage = 'Failed to fetch business: $e';
      log("$_errorMessage : $s");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new business
   Future<bool> createBusinessWithServices(BusinessModel business) async {
    try {
      // Ensure the business has required related data
      if (business.services.isEmpty) {
        log('Services list is empty or null');
        return false;
      }

      // Call the API to create business with services
      final response = await _apiService.postData(
        '/businesses/create_business',
        data: business.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Business created successfully with services');
        return true;
      } else {
        log('Failed to create business: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      log('Error creating business: $e');
      return false;
    }
  }

  // Update an existing business
  Future<bool> updateBusiness(BusinessModel business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Response response = await _apiService.postData(
        '/businesses/update_business',
        data: business.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update business');
      }
    } catch (e) {
      _errorMessage = 'Failed to update business: $e';
      log("Error : $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


Future<bool> updateService(BusinessModel business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Response response = await _apiService.postData(
        '/services/update_service',
        data: business.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update business');
      }
    } catch (e) {
      _errorMessage = 'Failed to update business: $e';
      log("Error Message $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}