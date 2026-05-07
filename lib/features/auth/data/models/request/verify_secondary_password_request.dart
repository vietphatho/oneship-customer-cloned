import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_secondary_password_request.freezed.dart';
part 'verify_secondary_password_request.g.dart';

@freezed
abstract class VerifySecondaryPasswordRequest with _$VerifySecondaryPasswordRequest {
  const factory VerifySecondaryPasswordRequest({
    @JsonKey(name: "secondPassword") String? secondPassword,
  }) = _VerifySecondaryPasswordRequest;

  factory VerifySecondaryPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifySecondaryPasswordRequestFromJson(json);
}
