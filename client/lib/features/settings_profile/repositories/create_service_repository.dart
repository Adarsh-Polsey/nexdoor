import 'dart:developer';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/services_model.dart';

class CreateServiceRepository {
  final ApiService _apiService=ApiService();

  CreateServiceRepository();

  Future<ServicesModel> fetchUserService() async {
  try {
    final response = await _apiService.getData('/services/get_service');

    if (response.statusCode == 200) {
      List<dynamic> data = response.data; // Ensure it's treated as a list
      if (data.isNotEmpty) {
        return ServicesModel.fromJson(data.first); // Get the first service
      } else {
        throw Exception("No services found");
      }
    }
    
    log('Failed to fetch services: ${response.statusCode}');
    throw Exception("Error fetching services");
  } catch (e) {
    log('Error fetching services: $e');
    rethrow;
  }
}
  // Fetch services for a specific business
  Future<List<ServicesModel>> fetchBusinessServices(String businessId) async {
    try {
      final response = await _apiService.getData(
        '/services/list_services',
        queryParameters: {'business_id': businessId},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ServicesModel.fromJson(json))
            .toList();
      }
      
      log('Failed to fetch services: ${response.statusCode}');
      return [];
    } catch (e) {
      log('Error fetching services: $e');
      rethrow;
    }
  }

  // Get a specific service by ID
  Future<ServicesModel?> getServiceById(String serviceId) async {
    try {
      final response = await _apiService.getData(
        '/services/get_service',
        queryParameters: {'service_id': serviceId},
      );

      if (response.statusCode == 200) {
        return ServicesModel.fromJson(response.data);
      }
      
      log('Failed to fetch service: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error fetching service: $e');
      rethrow;
    }
  }

  // Create a new service
  Future<ServicesModel?> createService(ServicesModel service) async {
    try {
      final response = await _apiService.postData(
        '/services/create_service',
        data: service.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ServicesModel.fromJson(response.data);
      }
      
      log('Failed to create service: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error creating service: $e');
      rethrow;
    }
  }

  // Update an existing service
  Future<ServicesModel?> updateService(ServicesModel service) async {
    try {
      final response = await _apiService.putData(
        '/services/update_service/',
        data: service.toJson(),
      );

      if (response.statusCode == 200) {
        return ServicesModel.fromJson(response.data);
      }
      
      log('Failed to update service: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error updating service: $e');
      rethrow;
    }
  }

  // Delete a service
  Future<bool> deleteService(String serviceId) async {
    try {
      final response = await _apiService.deleteData(
        '/services/delete_service/$serviceId',
      );

      return response.statusCode == 204;
    } catch (e) {
      log('Error deleting service: $e');
      return false;
    }
  }

  // Search services
  Future<List<ServicesModel>> searchServices({
    String? query,
    String? businessId,
  }) async {
    try {
      final response = await _apiService.getData(
        '/services/list_services',
        queryParameters: {
          if (query != null) 'search': query,
          if (businessId != null) 'business_id': businessId,
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ServicesModel.fromJson(json))
            .toList();
      }
      
      log('Failed to search services: ${response.statusCode}');
      return [];
    } catch (e) {
      log('Error searching services: $e');
      rethrow;
    }
  }
}