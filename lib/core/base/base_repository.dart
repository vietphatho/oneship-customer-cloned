import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oneship_customer/core/base/constants/error_code.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';

abstract class BaseRepository {
  E? parseError<E>(
    Map<String, dynamic>? error, {
    required E Function(Map<String, dynamic>) parsing,
  }) {
    if (error == null) return null;
    return parsing(error);
  }

  Future<Resource<T>> request<T, E>(
    Future<BaseResponse<T, E>> Function() request, {
    E Function(Map<String, dynamic> errorJson)? errorParsing,
  }) async {
    try {
      final response = await request();
      bool? apiResult = response.success == true;
      if (apiResult == true) {
        return Resource.success(response.result as T);
      } else if (apiResult == false) {
        return Resource.error(
          ErrorCodeEnumExt.getMessage(response.errorCode) ??
              response.message ??
              'error_code.unknown',
          0,
          err: response.error,
        );
      } else {
        return Resource.loading();
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        return Resource.error('network_error_mess', 0, err: e);
      }

      try {
        var response = e.response?.data;
        // logger.e(response);
        var error = response["error"];
        var parsedErr;

        if (error is Map<String, dynamic>) {
          parsedErr = parseError(
            response["error"],
            parsing: errorParsing ?? (_) => null,
          );
        } else if (error is String) {
          parsedErr = error;
        }

        return Resource.error(
          ErrorCodeEnumExt.getMessage(response["errorCode"]) ??
              response["message"] ??
              'error_code.server_error',
          e.response?.statusCode ?? 0,
          err: parsedErr ?? error,
          errorCode: response["errorCode"],
        );
      } catch (_) {
        return Resource.error('error_code.server_error', 0, err: e);
      }
    } catch (e) {
      return Resource.error('error_code.server_error', 0, err: e);
    }
  }
}
