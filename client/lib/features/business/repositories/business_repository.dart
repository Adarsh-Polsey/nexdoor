import 'dart:developer';

import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/booking_model.dart';
import '../models/business_model.dart';

class BusinessRepository {
  final ApiService apiService = ApiService();

  Future<List<BusinessModel>> fetchBusinesses({String? search}) async {
    try {
      final response = await apiService.getData(
        "/businesses/list_businesses",
        queryParameters: search != null ? {"search": search} : {},
      );
      
      log("Fetch Businesses Response: ${response.data} (Status: ${response.statusCode})");
      
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => BusinessModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        log("Failed to load businesses: Invalid response");
        throw Exception("Failed to load businesses");
      }
    } catch (e) {
      log("Error fetching businesses: $e", error: e);
      rethrow;
    }
  }

  Future<List<String>> fetchUnavailableHours(String serviceId) async {
    try {
      final response = await apiService.getData(
        '/api/v1/bookings/list_booking',
        queryParameters: {'service_id': serviceId},
      );
      
      log("Unavailable Hours Response: ${response.data} (Status: ${response.statusCode})");
      
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((booking) => booking['time_slot'] as String)
            .toList();
      } else {
        log("Failed to fetch unavailable hours: Invalid response");
        throw Exception('Failed to fetch unavailable hours');
      }
    } catch (e) {
      log("Error fetching unavailable hours: $e", error: e);
      rethrow;
    }
  }
  Future<List<String>> fetchAvailableHours(String serviceId) async {
    try {
      final response = await apiService.getData(
        '/api/v1/services/available_hours',
        queryParameters: {'service_id': serviceId},
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((hour) => hour.toString()).toList();
      } else {
        throw Exception('Failed to fetch available hours');
      }
    } catch (e) {
      log("Error fetching available hours: $e");
      throw Exception('Failed to fetch available hours: $e');
    }
  }

  Future<List<DateTime>> fetchAvailableDates(String serviceId) async {
    try {
      final response = await apiService.getData(
        '/api/v1/services/available_dates',
        queryParameters: {'service_id': serviceId},
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((dateString) => DateTime.parse(dateString))
            .toList();
      } else {
        throw Exception('Failed to fetch available dates');
      }
    } catch (e) {
      log("Error fetching available dates: $e");
      throw Exception('Failed to fetch available dates: $e');
    }
  }

  Future<bool> createBooking(Map<String, dynamic> bookingDetails) async {
    try {
      // Validate booking details
      if (bookingDetails['serviceId'] == null || 
          bookingDetails['hour'] == null || 
          bookingDetails['date'] == null) {
        throw Exception('Incomplete booking details');
      }

      // Create booking model
      final booking = BookingModel(
        id: '',  // Will be assigned by server
        serviceId: bookingDetails['serviceId'],
        timeSlot: '${bookingDetails['date'].toString().split(' ')[0]}-${bookingDetails['hour']}',
        status: 'pending',
      );
      
      // Make API call
      final response = await apiService.postData(
        '/api/v1/bookings/create_booking',
        data: booking.toJson(),
      );
      
      log("Create Booking Response: ${response.data} (Status: ${response.statusCode})");
      
      // Check response and return booking status
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log("Booking creation failed: ${response.data}");
        return false;
      }
    } catch (e) {
      log("Error creating booking: $e", error: e);
      rethrow;
    }
  }
}