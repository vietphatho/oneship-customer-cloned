import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_password_request.freezed.dart';
part 'update_password_request.g.dart';

@freezed
abstract class UpdatePasswordRequest with _$UpdatePasswordRequest {
  const factory UpdatePasswordRequest({
    @JsonKey(name: "currentPassword") required String currentPassword,
    @JsonKey(name: "secondPassword") required String secondPassword,
    @JsonKey(name: "newPassword") required String newPassword,
  }) = _UpdatePasswordRequest;

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordRequestFromJson(json);
}
