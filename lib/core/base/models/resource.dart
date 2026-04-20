import 'package:oneship_customer/core/base/constants/enum.dart';

class Resource<T> {
  final Result _state;
  final T? _data;
  final String? _message;
  final int? _statusCode;
  final String? _errorCode;
  final dynamic _err;

  Resource<T> copyWith({
    Result? state,
    T? data,
    String? message,
    int? statusCode,
  }) {
    return Resource(
      state: state ?? _state,
      data: data ?? _data,
      message: message ?? _message,
      statusCode: statusCode ?? _statusCode,
    );
  }

  Resource({required state, data, message, statusCode, errorCode, err})
    : _state = state,
      _data = data,
      _message = message,
      _statusCode = statusCode,
      _err = err,
      _errorCode = errorCode;

  static Resource<T> success<T>(T data) =>
      Resource(state: Result.success, data: data);

  static Resource<T> error<T>(
    String errorMsg,
    int statusCode, {
    String? errorCode,
    dynamic err,
  }) => Resource(
    state: Result.error,
    data: null,
    message: errorMsg,
    statusCode: statusCode,
    errorCode: errorCode,
    err: err,
  );

  static Resource<T> loading<T>({T? data}) =>
      Resource(state: Result.loading, data: data);

  // static Future<Resource<T>> guardFuture<T>(Future<T> future) async {
  //   try {
  //     final data = await future;
  //     return Resource.success(data);
  //   } on DioException catch (dioErr) {
  //     final message =
  //         dioErr.response?.data?['message'] ??
  //         dioErr.message ??
  //         'Unknown error';
  //     final statusCode = dioErr.response?.statusCode;
  //     return Resource.error(message, statusCode ?? 0);
  //   } catch (e) {
  //     return Resource.error(e.toString(), 0);
  //   }
  // }

  Resource<O> parse<O>(O Function(T origin) parser) {
    if (_state == Result.loading) {
      return Resource.loading();
    }

    if (_state == Result.error) {
      return Resource.error(
        message,
        statusCode,
        errorCode: _errorCode,
        err: _err,
      );
    }

    // ===== SAFE CHECK =====
    final rawData = _data;
    if (rawData == null) {
      return Resource.error("Data is null", statusCode, errorCode: _errorCode);
    }

    final parsed = parser(rawData);
    return Resource.success(parsed);
  }

  Result get state => _state;

  T? get data => _data;

  String get message => _message ?? "";

  int get statusCode => _statusCode ?? 0;

  dynamic get err => _err;

  String? get errorCode => _errorCode;
}
