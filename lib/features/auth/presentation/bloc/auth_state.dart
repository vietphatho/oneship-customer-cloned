import 'package:oneship_customer/features/auth/data/models/response/login_response.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';

import '../../../../core/base/models/resource.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

// class AuthLoadingState extends AuthState {
//   const AuthLoadingState();
// }

// class AuthSuccessState extends AuthState {
//   const AuthSuccessState();
// }

// class AuthErrorState extends AuthState {
//   const AuthErrorState();
// }

// class CurrentRegistrationState extends AuthState {}

// class GenOtpCodeState extends AuthState {
//   final Resource<OtpResult> resource;
//   const GenOtpCodeState(this.resource);
// }

class AuthRegisterState extends AuthState {
  final Resource resource;

  AuthRegisterState(this.resource);
}

class AuthLoggedInState extends AuthState {
  final Resource<LoginResponse> resource;

  AuthLoggedInState(this.resource);
}

class AuthFetchedUserProfileState extends AuthState {
  final Resource<UserProfileResponse> resource;

  AuthFetchedUserProfileState(this.resource);
}

class AuthUpdatedUserProfileState extends AuthState {
  final Resource<UserProfileResponse> resource;

  AuthUpdatedUserProfileState(this.resource);
}

class AuthLogOutState extends AuthState {
  final Resource resource;

  AuthLogOutState(this.resource);
}

// class AuthUpdatedFcmTokenState extends AuthState {
//   final Resource resource;

//   AuthUpdatedFcmTokenState(this.resource);
// }
