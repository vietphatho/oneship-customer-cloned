import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_second_password_request.freezed.dart';
part 'create_second_password_request.g.dart';

@freezed
abstract class CreateSecondPasswordRequest with _$CreateSecondPasswordRequest {
  const factory CreateSecondPasswordRequest({
    @JsonKey(name: "currentPassword") required String currentPassword,
    @JsonKey(name: "secondPassword") required String secondPassword,
  }) = _CreateSecondPasswordRequest;

  factory CreateSecondPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSecondPasswordRequestFromJson(json);
}
