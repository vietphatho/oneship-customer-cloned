import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class BaseResponse<T, E> with _$BaseResponse<T, E> {
  const factory BaseResponse({
    bool? success,
    String? message,
    String? errorCode,
    E? error,
    T? result,
    DateTime? timestamp,
    String? path,
  }) = _BaseResponse<T, E>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
    E Function(Object?) fromJsonE,
  ) => _$BaseResponseFromJson(json, fromJsonT, fromJsonE);
}
