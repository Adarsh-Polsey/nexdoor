import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/business_model.dart';

class CreateBusinessRepository {
  final ApiService _apiService;

  CreateBusinessRepository(this._apiService);

  // Fetch user's businesses
  Future<BusinessModel> fetchUserBusiness() async {
    try {
      final response = await _apiService.getData('/businesses/get_business');
      
      if (response.statusCode == 200) {
        return ( BusinessModel.fromJson(response.data));
      }
      else {
        log('Failed to fetch businesses: ${response.statusCode}');
        throw Exception("Error fetching business");
      };
    } catch (e) {
      log('Error fetching businesses: $e');
      rethrow;
    }
  }

  // Get a specific business by ID
  Future<BusinessModel?> getBusinessById(String? businessId) async {
    try {
       Map<String, dynamic>? queryParameters = {};
      businessId == null?queryParameters = {}:queryParameters = {'business_id': businessId};
      final response = await _apiService.getData(
        '/businesses/get_business',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return BusinessModel.fromJson(response.data);
      }
      
      log('Failed to fetch business: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error fetching business: $e');
      rethrow;
    }
  }

  // Create a new business
  Future<BusinessModel?> createBusiness(BusinessModel business) async {
    try {
      final response = await _apiService.postData(
        '/businesses/create_business',
        data: business.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessModel.fromJson(response.data);
      }
      
      log('Failed to create business: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error creating business: $e');
      rethrow;
    }
  }

  // Update an existing business
  Future<BusinessModel?> updateBusiness(BusinessModel business) async {
    try {
      final response = await _apiService.postData(
        '/businesses/update_business',
        data: business.toJson(),
      );

      if (response!= null) {
        return BusinessModel.fromJson(response);
      }
      
      log('Failed to update business: ${response.statusCode}');
      return null;
    } catch (e,s) {
      log('Error updating business: $e $s');
      rethrow;
    }
  }

  // Delete a business
  Future<bool> deleteBusiness(String businessId) async {
    try {
      final response = await _apiService.deleteData(
        '/businesses/delete_business/$businessId',
      );

      return response.statusCode == 204;
    } catch (e) {
      log('Error deleting business: $e');
      return false;
    }
  }
}