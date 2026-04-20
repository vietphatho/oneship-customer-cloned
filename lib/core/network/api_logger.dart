import 'package:dio/dio.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';

class ApiLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger().log(
      "REQUEST API",
      detail:
          "url: ${options.uri}; "
          "data: ${options.data}",
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger().log(
      "RESPONSE API",
      detail:
          "${response.statusCode}; "
          "url: ${response.requestOptions.uri}; "
          "data: ${response.data}",
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger().log("ERROR API", detail: "${err.type} ${err.message} ");
    super.onError(err, handler);
  }
}
