import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_request.freezed.dart';
part 'verify_email_request.g.dart';

@freezed
abstract class VerifyEmailRequest with _$VerifyEmailRequest {
  const factory VerifyEmailRequest({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "code") String? code,
  }) = _VerifyEmailRequest;

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestFromJson(json);
}
