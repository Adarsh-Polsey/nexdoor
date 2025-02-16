
import 'package:nexdoor/common/services/api_service.dart';
import '../models/business_model.dart';

class BusinessRepository {
final ApiService apiService=ApiService();

  Future<List<BusinessModel>> fetchBusinesses({String? search}) async {
    try {
      final response = await apiService.getData(
        "/list_businesses",
        queryParameters: search != null ? {"search": search} : {},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => BusinessModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load businesses");
      }
    } catch (e) {
      throw Exception("Error fetching businesses: $e");
    }
  }
}