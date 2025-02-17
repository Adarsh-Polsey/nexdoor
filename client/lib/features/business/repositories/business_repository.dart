import 'dart:developer';

import 'package:nexdoor/common/services/api_service.dart';
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
}
