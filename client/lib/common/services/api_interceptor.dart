import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nexdoor/common/utils/shared_prefs/shared_prefs.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';

class ApiInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? userId = await SharedPrefs.getUserId();
    final data = options.queryParameters;
    log("data: $data");
    log("onRequest: $userId");
    if (userId != null) {
      options.headers["user-id"] = userId;
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options=err.requestOptions;
      String? userId="";
    if (err.response?.statusCode == 401||err.response?.statusCode == 403) {
      await SharedPrefs.clearUserId();
      log("onError: 1$userId");
      userId=await AuthRepository().getId();
      log("onError: 2$userId");
      await SharedPrefs.saveUserId(userId!);
    }
    if (userId.isNotEmpty) {
      options.headers["user-id"] = userId;
    }
    else{
      throw Exception("Unauthorized");
    }
  }
}