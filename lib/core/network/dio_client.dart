// lib/core/network/dio_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/network/api_logger.dart';

import 'api_interceptor.dart';
import 'token_manager.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(TokenManager tokenManager) {
    String baseUrl = Constants.endpoint;
    // dotenv.env[Constant.endpointKey] ?? "";

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Constants.connectTimeout,
        receiveTimeout: Constants.receiveTimeout,
        sendTimeout: Constants.sendTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(ApiInterceptor(tokenManager, dio));
    dio.interceptors.add(ApiLogger());
    return dio;
  }

  @lazySingleton
  TokenManager tokenManager() => TokenManager();
}
