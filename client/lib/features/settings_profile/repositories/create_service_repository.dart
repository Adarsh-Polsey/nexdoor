import 'dart:developer';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/services_model.dart';

class CreateServiceRepository {
  final ApiService _apiService;

  CreateServiceRepository(this._apiService);

   Future<ServiceModel> fetchUserService() async {
    try {
      final response = await _apiService.getData(
        '/services/get_service',
      );

      if (response.statusCode == 200) {
        return (ServiceModel.fromJson(response.data));
      }
      
      log('Failed to fetch services: ${response.statusCode}');
      throw Exception("Error fetching services");
    } catch (e) {
      log('Error fetching services: $e');
      rethrow;
    }
  }

  // Fetch services for a specific business
  Future<List<ServiceModel>> fetchBusinessServices(String businessId) async {
    try {
      final response = await _apiService.getData(
        '/services/list_services',
        queryParameters: {'business_id': businessId},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ServiceModel.fromJson(json))
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
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final response = await _apiService.getData(
        '/services/get_service',
        queryParameters: {'service_id': serviceId},
      );

      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data);
      }
      
      log('Failed to fetch service: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error fetching service: $e');
      rethrow;
    }
  }

  // Create a new service
  Future<ServiceModel?> createService(ServiceModel service) async {
    try {
      final response = await _apiService.postData(
        '/services/create_service',
        data: service.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ServiceModel.fromJson(response.data);
      }
      
      log('Failed to create service: ${response.statusCode}');
      return null;
    } catch (e) {
      log('Error creating service: $e');
      rethrow;
    }
  }

  // Update an existing service
  Future<ServiceModel?> updateService(ServiceModel service) async {
    try {
      final response = await _apiService.putData(
        '/services/update_service/${service.id}',
        data: service.toJson(),
      );

      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data);
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
  Future<List<ServiceModel>> searchServices({
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
            .map((json) => ServiceModel.fromJson(json))
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