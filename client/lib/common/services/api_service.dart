import 'dart:developer';

import 'package:dio/dio.dart';
import 'api_interceptor.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000/api/v1",  // Ensure this is correct for your local API
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  ApiService() {
    _dio.interceptors.add(ApiInterceptor()); // Attach interceptor
  }

  // 🔹 GET Request: Handles token expiration & network errors
  Future<dynamic> getData(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final Response<dynamic> response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      return _handleDioError(e);
    } on Exception {
      rethrow;
    }
  }

  // 🔹 POST Request: Handles errors properly
  Future<dynamic> postData(String endpoint, {Object? data}) async {
    try {
      final Response<dynamic> response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      return _handleDioError(e);
    } on Exception {
      rethrow;
    }
  }

  // 🔹 Handles API Errors
  dynamic _handleDioError(DioException e) {
    if (e.response?.statusCode == null) {
      return {"error": "No internet connection. Please try again later."};
    } else if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
      return {"error": "Unauthorized access (${e.response?.statusCode})."};
    } else if (e.response?.statusCode == 488) {
      return {"error": "User has been blocked."};
    } else {
      return {"error": "Unexpected error (${e.response?.statusCode})."};
    }
  }
}