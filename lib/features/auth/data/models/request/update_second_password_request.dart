import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_second_password_request.freezed.dart';
part 'update_second_password_request.g.dart';

@freezed
abstract class UpdateSecondPasswordRequest with _$UpdateSecondPasswordRequest {
  const factory UpdateSecondPasswordRequest({
    @JsonKey(name: "currentPassword") required String currentPassword,
    @JsonKey(name: "currentSecondPassword") required String currentSecondPassword,
    @JsonKey(name: "newSecondPassword") required String newSecondPassword,
  }) = _UpdateSecondPasswordRequest;

  factory UpdateSecondPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSecondPasswordRequestFromJson(json);
}
