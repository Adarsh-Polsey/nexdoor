import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/settings_profile/models/business_model.dart';


class BusinessViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Business> _businesses = [];
  bool _isLoading = false;

  List<Business> get businesses => _businesses;
  bool get isLoading => _isLoading;

  Future<void> fetchBusinesses({int skip = 0, int limit = 10, String search = ''}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getData('/api/v1/businesses/list_businesses', queryParameters: {
        'skip': skip.toString(),
        'limit': limit.toString(),
        'search': search,
      });

      _businesses = (response['data'] as List).map((business) => Business.fromJson(business)).toList();
    } catch (e) {
      print('Error fetching businesses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBusiness(Business business) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Response response = await _apiService.postData('/businesses/create_business', data: business.toJson());
      // _businesses.add(Business.fromJson(response.data));
      log("Response data: "+response.data);
      log("Status code: "+response.statusCode.toString());
      return response.data;
    } catch (e) {
      print('Error creating business: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}