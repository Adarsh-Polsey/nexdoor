import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/services_model.dart';

class ServiceViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<ServiceModel> _services = [];

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create a new service
  Future<bool> createService(ServiceModel service) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postData(
        '/services/create_service',
        data: service.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create service');
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all services for current user
Future<ServiceModel> getService() async {
  _isLoading = true;
  notifyListeners();

  try {
    final Response response =
        await _apiService.getData('/services/get_service');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data; // No need to decode
      final service = ServiceModel.fromJson(responseData);
      
      _isLoading = false;
      notifyListeners();
      
      return service;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load service: ${response.data['message']}');
    }
  } catch (e, s) {
    _isLoading = false;
    notifyListeners();
    log('Error getting service: ${e.toString()}, $s');
    throw Exception('Error getting service: ${e.toString()}, $s');
  }
}

  // Get service by ID
  Future<ServiceModel> getServiceById(String serviceId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Response response =
          await _apiService.getData('/services/get_service/$serviceId');

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.data);
        final service = ServiceModel.fromJson(responseData);
        _isLoading = false;
        notifyListeners();
        return service;
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to find the service: ${response.statusCode}');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error getting service');
    }
  }

  // Update existing service
  Future<bool> updateService(ServiceModel service) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Response response = await _apiService.postData(
          "/services/update_service",
          data: json.encode(service.toJson()));

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final index = _services.indexWhere((s) => s.id == service.id);
        if (index != -1) {
          _services[index] = service;
          notifyListeners();
        }
        return true;
      } else {
        throw Exception('Failed to update service: ${response.data}');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error updating service: ${e.toString()}');
    }
  }
}
