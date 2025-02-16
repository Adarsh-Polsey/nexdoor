import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/settings_profile/models/services_model.dart';

class ServiceViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create a new service
  Future<bool> createService(Service service) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postData(
        '/create_service',
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
}