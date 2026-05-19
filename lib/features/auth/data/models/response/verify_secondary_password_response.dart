import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_secondary_password_response.freezed.dart';
part 'verify_secondary_password_response.g.dart';

@freezed
abstract class VerifySecondaryPasswordResponse with _$VerifySecondaryPasswordResponse {
    const factory VerifySecondaryPasswordResponse({
        @JsonKey(name: "message")
        String? message,
        @JsonKey(name: "secondPasswordToken")
        String? secondPasswordToken,
        @JsonKey(name: "expiresIn")
        String? expiresIn,
    }) = _VerifySecondaryPasswordResponse;

    factory VerifySecondaryPasswordResponse.fromJson(Map<String, dynamic> json) => _$VerifySecondaryPasswordResponseFromJson(json);
}
