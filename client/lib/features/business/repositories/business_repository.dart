import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/business/models/booking_model.dart';
import 'package:nexdoor/features/business/models/business_model.dart';

class BusinessRepository {
  final ApiService apiService=ApiService();
  Future<List<BusinessModel>> fetchBusinesses({String? search}) async {
    try {
      final response = await apiService.getData(
        "/businesses/list_businesses",
        queryParameters: search != null ? {"search": search} : {},
      );      
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

  Future<BusinessModel> getBusinessDetails() async {
    try{
      final response = await apiService.getData(
        "/businesses/get_business/",
      );      
      return BusinessModel.fromJson(response.data);}
      catch(e,s){
        log("Error fetching business details: $e $s", error: e);
        rethrow;
      }
  }
}

// booking_repository.dart
class BookingRepository {
    final ApiService apiService=ApiService();


  BookingRepository();

  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await apiService.postData(
      '/api/v1/bookings/create_booking',
      data: booking.toJson(),
    );
    
    return BookingModel.fromJson(response);
  }

  Future<List<BookingModel>> getBusinessBookings(String businessId, String date) async {
    final response = await apiService.getData(
      "/bookings/list_booking",
      queryParameters: {
        "business_id": businessId,
        "date": date,
      },
    );
    
    final List<dynamic> bookingsJson = response.data;
    return bookingsJson.map((booking) => BookingModel.fromJson(booking)).toList();
  }
}