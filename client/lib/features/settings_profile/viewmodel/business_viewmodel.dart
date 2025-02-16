// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:nexdoor/common/services/api_service.dart';
// import 'package:nexdoor/features/business/models/business_model.dart';

// class BusinessViewModel with ChangeNotifier {
//   final ApiService _apiService = ApiService();
//   List<BusinessModel> _businesses = [];
//   BusinessModel? _business; // Store the fetched business data
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<BusinessModel> get businesses => _businesses;
//   BusinessModel? get business => _business;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // Fetch a single business by ID
//   Future<BusinessModel?> fetchABusiness({String? businessId}) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final Response response = await _apiService.getData(
//         '/businesses/get_business',
//         queryParameters: businessId != null ? {'business_id': businessId} : {},
//       );

//       if (response.statusCode == 200) {
//         _business = BusinessModel.fromJson(response.data);
//         return _business;
//       } else {
//         throw Exception('No business data found');
//       }
//     } catch (e,s) {
//       _errorMessage = 'Failed to fetch business: $e';
//       print("$_errorMessage : $s");
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Create a new business
//   Future<bool> createBusiness(BusinessModel business) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final Response response = await _apiService.postData(
//         '/businesses/create_business',
//         data: business.toJson(),
//       );

//       if (response.statusCode == 201) {
//         return true;
//       } else {
//         throw Exception('Failed to create business');
//       }
//     } catch (e) {
//       _errorMessage = 'Failed to create business: $e';
//       print(_errorMessage);
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Update an existing business
//   Future<bool> updateBusiness(BusinessModel business) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final Response response = await _apiService.postData(
//         '/businesses/update_business',
//         data: business.toJson(),
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw Exception('Failed to update business');
//       }
//     } catch (e) {
//       _errorMessage = 'Failed to update business: $e';
//       print(_errorMessage);
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
