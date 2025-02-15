import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/settings_profile/models/business_model.dart';

class BusinessViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Business> _businesses = [];
  Business? _business; // Store the fetched business data
  bool _isLoading = false;
  String? _errorMessage;

  List<Business> get businesses => _businesses;
  Business? get business => _business;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch a list of businesses
  Future<void> fetchBusinesses({int skip = 0, int limit = 10, String search = ''}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getData(
        '/api/v1/businesses/list_businesses',
        queryParameters: {
          'skip': skip.toString(),
          'limit': limit.toString(),
          'search': search,
        },
      );

      _businesses = (response['data'] as List).map((business) => Business.fromJson(business)).toList();
    } catch (e) {
      _errorMessage = 'Failed to fetch businesses: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a single business by ID
  Future<Business?> fetchABusiness({String? businessId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getData(
        'businesses/get_business',
        queryParameters: businessId != null ? {'business_id': businessId} : {},
      );

      if (response != null && response['data'] != null) {
        _business = Business.fromJson(response['data']);
        return _business;
      } else {
        throw Exception('No business data found');
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch business: $e';
      print(_errorMessage);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new business
  Future<bool> createBusiness(Business business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Response response = await _apiService.postData(
        '/businesses/create_business',
        data: business.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create business');
      }
    } catch (e) {
      _errorMessage = 'Failed to create business: $e';
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing business
  Future<bool> updateBusiness(Business business) async {
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
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}