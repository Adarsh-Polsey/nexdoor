
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:nexdoor/common/services/api_service.dart';
// import '../models/business_model.dart';

// class BusinessRepository {
// final ApiService apiService=ApiService();

//   Future<List<BusinessModel>> fetchBusinesses({String? search}) async {
//     try {
//       final Response response = await apiService.getData(
//         "/businesses/list_businesses",
//         queryParameters: search != null ? {"search": search} : {},
//       );
//       log("Response from fetchBusinesses(): $response");
//       if (response.statusCode == 200) {
//         return (response.data as List).map((json) => BusinessModel.fromJson(json)).toList();
//       } else {
//         throw Exception("Failed to load businesses");
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }