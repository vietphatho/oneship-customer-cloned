import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/create_second_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/fetch_user_profile_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_second_password_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/update_user_profile_use_case.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._logInUseCase,
    this._logOutUseCase,
    this._fetchUserProfileUseCase,
    this._updateUserProfileUseCase,
    this._updatePasswordUseCase,
    this._createSecondPasswordUseCase,
    this._updateSecondPasswordUseCase,
  ) : super(const AuthInitialState()) {
    on<AuthLoginEvent>(_onLoginEvent);
    on<AuthFetchingUserProfileEvent>(_onProfileFetchedEvent);
    on<AuthUpdateUserProfileEvent>(_onProfileUpdatedEvent);
    on<AuthLogOutEvent>(_onLogOutEvent);
    on<AuthUpdatePasswordEvent>(_onPasswordUpdatedEvent);
  }

  final LogInUseCase _logInUseCase;
  final LogOutUseCase _logOutUseCase;
  final FetchUserProfileUseCase _fetchUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final CreateSecondPasswordUseCase _createSecondPasswordUseCase;
  final UpdateSecondPasswordUseCase _updateSecondPasswordUseCase;

  late UserProfileResponse _userProfile;
  UserProfileResponse get userProfile => _userProfile;

  Future<void> _onLoginEvent(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoggedInState(Resource.loading()));

    LoginRequest request = LoginRequest(
      login: event.userName,
      password: event.password,
    );
    final response = await _logInUseCase.call(request);

    emit(AuthLoggedInState(response));
  }

  FutureOr<void> _onProfileFetchedEvent(
    AuthFetchingUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthFetchedUserProfileState(Resource.loading()));
    final response = await _fetchUserProfileUseCase.call();
    if (response.state == Result.success) {
      _userProfile = response.data!;
    }
    emit(AuthFetchedUserProfileState(response));
  }

  FutureOr<void> _onLogOutEvent(
    AuthLogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLogOutState(Resource.loading()));
    final response = await _logOutUseCase.call();
    emit(AuthLogOutState(response));
  }

  FutureOr<void> _onProfileUpdatedEvent(
    AuthUpdateUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedUserProfileState(Resource.loading()));

    final response = await _updateUserProfileUseCase.call(
      id: userProfile.id.toString(),
      request: event.request,
    );

    if (response.state == Result.success) {
      _userProfile = response.data!;
    }
    emit(AuthUpdatedUserProfileState(response));
  }

  FutureOr<void> _onPasswordUpdatedEvent(
    AuthUpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdatedPasswordState(Resource.loading()));

    late Resource response;
    switch (event.updateType) {
      case AuthUpdatePasswordType.main:
        response = await _updatePasswordUseCase.call(event.body);
        break;
      case AuthUpdatePasswordType.createSecondary:
        response = await _createSecondPasswordUseCase.call(event.body);
        break;
      case AuthUpdatePasswordType.updateSecondary:
        response = await _updateSecondPasswordUseCase.call(event.body);
        break;
    }

    emit(AuthUpdatedPasswordState(response));
  }

  void updatePassword(dynamic body, {AuthUpdatePasswordType updateType = AuthUpdatePasswordType.main}) {
    add(AuthUpdatePasswordEvent(body, updateType: updateType));
  }

  void updateUserProfile({String? displayName, String? userPhone}) {
    add(
      AuthUpdateUserProfileEvent(
        UpdateUserProfileRequest(
          displayName: displayName ?? _userProfile.displayName,
          userPhone: userPhone ?? _userProfile.userPhone,
        ),
      ),
    );
  }

  void login({required String userName, required String password}) {
    add(AuthLoginEvent(userName: userName, password: password));
  }

  void logOut() {
    add(AuthLogOutEvent());
  }

  void fetchUserProfile() {
    add(const AuthFetchingUserProfileEvent());
  }
}
