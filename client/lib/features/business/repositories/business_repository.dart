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
      log("message from fetchBusinesses(): $response ${response.statusCode}");
      if (response.statusCode == 200&&response.data is List) {
          return (response.data as List)
              .map((json) =>
                  BusinessModel.fromJson(json as Map<String, dynamic>))
              .toList();
      } else {
        log("Failed to load businesses");
        throw Exception("Failed to load businesses");
      }
    } catch (e) {
      log("Error fetching businesses: $e");
      throw Exception("Error fetching businesses: $e");
    }
  }
   Future<List<String>> fetchUnavailableHours(String serviceId) async {
    try {
      final response = await apiService.getData('/api/v1/bookings/list_booking?service_id=$serviceId');
      final bookings = response.body as List<dynamic>;
      return bookings.map((booking) => booking['time_slot'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch unavailable hours: $e');
    }
  }

  Future<bool> createBooking(String serviceId, String timeSlot) async {
    try {
      final booking = BookingModel(
        id: '',  // Will be assigned by server
        serviceId: serviceId,
        timeSlot: timeSlot,
        status: 'pending',
      );
      
      final response = await apiService.postData(
        '/api/v1/bookings/create_booking',data:booking.toJson(),
      );
      print(response.statusCode);
      
      return true;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

}