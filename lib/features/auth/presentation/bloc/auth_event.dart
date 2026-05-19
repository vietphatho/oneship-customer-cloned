import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_second_password_request.dart';

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


class AuthUpdatePasswordEvent extends AuthEvent {
  final UpdatePasswordRequest body;
  AuthUpdatePasswordEvent(this.body);
}

class AuthCreateSecondPasswordEvent extends AuthEvent {
  final CreateSecondPasswordRequest body;
  AuthCreateSecondPasswordEvent(this.body);
}

class AuthUpdateSecondPasswordEvent extends AuthEvent {
  final UpdateSecondPasswordRequest body;
  AuthUpdateSecondPasswordEvent(this.body);
}

// class GenOtpCodeEvent extends AuthEvent {
//   final String phoneNumber;

//   GenOtpCodeEvent(this.phoneNumber);
// }

// class AuthUpdateFcmTokenEvent extends AuthEvent {
//   final String token;

//   AuthUpdateFcmTokenEvent(this.token);
// }
