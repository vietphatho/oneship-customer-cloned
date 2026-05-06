import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/error_code.dart';
import 'package:oneship_customer/core/navigation/app_navigator.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/storage/secure_storage.dart';
import 'package:oneship_customer/core/storage/secure_storage_key.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';

import 'token_manager.dart';

class ApiInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final Dio dio;

  Future<void>? _refreshFuture;

  ApiInterceptor(this.tokenManager, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isTokenExpired(err)) {
      AppLogger().log(
        "request token expired",
        detail: err.requestOptions.uri.path,
      );

      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken != null) {
        try {
          if (_refreshFuture != null) {
            await _refreshFuture;
            _refreshFuture = null;
          } else {
            _refreshFuture = _refreshToken(refreshToken);
            await _refreshFuture;
            _refreshFuture = null;
          }

          String? newAccessToken = await tokenManager.getAccessToken();
          // Gọi lại request ban đầu với token mới
          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';
          final newResponse = await dio.fetch(retryRequest);

          AppLogger().log("retried response", detail: newResponse.data);
          return handler.resolve(newResponse);
        } catch (e) {
          if (e is DioException && e.response?.statusCode == 401) {
            AppLogger().log("retried failed", detail: e);
            await SecureStorage.deleteSecureData(SecureStorageKey.userId);
            await tokenManager.clearTokens();
            // FunctionUtils.handleAfterLogOut();

            await Future.delayed(Durations.medium4);
            AppNavigator.globalContext.pushReplacement(RouteName.loginPage);
          } else {
            AppLogger().log("another error refresh token", detail: e);
            return handler.next(e is DioException ? e : err);
          }
        }
      } else {
        AppLogger().log(
          "refresh token is null",
          detail: err.requestOptions.uri.path,
        );
        await SecureStorage.deleteSecureData(SecureStorageKey.userId);
        // FunctionUtils.handleAfterLogOut();
        await Future.delayed(Durations.medium4);
        AppNavigator.globalContext.pushReplacement(RouteName.loginPage);
      }
      return;
    }

    handler.next(err);
  }

  bool _isTokenExpired(DioException err) {
    return err.response?.statusCode == 401 &&
        err.response?.data["errorCode"] == ErrorCodeEnum.auth005.key;
  }

  Future<void> _refreshToken(String refreshToken) async {
    final refreshDio = Dio(
      BaseOptions(headers: {'refresh-token': refreshToken}),
    );
    final endpoint = Constants.endpoint;
    // dotenv.env[Constant.endpointKey] ?? "";
    final response = await refreshDio.post(
      '$endpoint${Constants.refreshTokenEndpoint}',
    );

    AppLogger().log("refresh token result", detail: response.data);

    await tokenManager.saveTokens(
      accessToken: response.data['result']['access_token'],
      refreshToken: response.data['result']['refresh_token'],
    );
  }
}
