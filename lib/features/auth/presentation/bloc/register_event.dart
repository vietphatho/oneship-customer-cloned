import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_email_request.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterRequestEvent extends RegisterEvent {
  final RegisterRequest request;

  RegisterRequestEvent(this.request);
}

class RegisterVerifyEmailEvent extends RegisterEvent {
  final VerifyEmailRequest request;

  RegisterVerifyEmailEvent(this.request);
}

class RegisterSetUserEmailEvent extends RegisterEvent {
  final String userEmail;

  RegisterSetUserEmailEvent(this.userEmail);
}

class RegisterResendVerificationEmailEvent extends RegisterEvent {
  RegisterResendVerificationEmailEvent();
}
