import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nexdoor/common/utils/shared_prefs/shared_prefs.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      String? userId = await SharedPrefs.getUserId();
      log("onRequest: userId = $userId");
      if (userId != null) {
        options.headers["user-id"] = userId;
      } else {
        throw Exception("Unauthorized");
      }
      handler.next(options);
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final options = err.requestOptions;
      if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
        await SharedPrefs.clearUserId();
        log("onError: Clearing userId due to unauthorized/forbidden error");

        String? newUserId = await AuthRepository().getId();
        if (newUserId != null) {
          await SharedPrefs.saveUserId(newUserId);
          options.headers["user-id"] = newUserId;
          log("onError: New userId = $newUserId");

          // Retry the request with the new userId
          final response = await Dio().fetch(options);
          handler.resolve(response);
          return;
        } else {
          throw Exception("Failed to reauthenticate");
        }
      }
      handler.next(err);
    } catch (e) {
      handler.reject(DioException(requestOptions: err.requestOptions, error: e));
    }
  }
}