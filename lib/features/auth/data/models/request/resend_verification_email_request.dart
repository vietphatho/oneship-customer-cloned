import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_verification_email_request.freezed.dart';
part 'resend_verification_email_request.g.dart';

@freezed
abstract class ResendVerificationEmailRequest with _$ResendVerificationEmailRequest {
  const factory ResendVerificationEmailRequest({
    @JsonKey(name: "email") required String email,
  }) = _ResendVerificationEmailRequest;

  factory ResendVerificationEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationEmailRequestFromJson(json);
}
