import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_secondary_password_request.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthLoginEvent extends AuthEvent {
  final String userName;
  final String password;

  AuthLoginEvent({required this.userName, required this.password});
}

class AuthLogOutEvent extends AuthEvent {
  const AuthLogOutEvent();
}

class AuthFetchingUserProfileEvent extends AuthEvent {
  const AuthFetchingUserProfileEvent();
}

class AuthRegisterEvent extends AuthEvent {
  final RegisterRequest request;

  AuthRegisterEvent(this.request);
}

class AuthUpdateUserProfileEvent extends AuthEvent {
  final UpdateUserProfileRequest request;

  AuthUpdateUserProfileEvent(this.request);
}

class AuthVerifySecondaryPasswordEvent extends AuthEvent {
  final VerifySecondaryPasswordRequest request;

  AuthVerifySecondaryPasswordEvent(this.request);
}

// class GenOtpCodeEvent extends AuthEvent {
//   final String phoneNumber;

//   GenOtpCodeEvent(this.phoneNumber);
// }

// class AuthUpdateFcmTokenEvent extends AuthEvent {
//   final String token;

//   AuthUpdateFcmTokenEvent(this.token);
// }
