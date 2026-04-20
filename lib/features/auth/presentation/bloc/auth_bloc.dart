import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/fetch_user_profile_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._logInUseCase,
    this._logOutUseCase,
    this._fetchUserProfileUseCase,
  ) : super(const AuthInitialState()) {
    on<AuthLoginEvent>(_onLoginEvent);
    on<AuthFetchingUserProfileEvent>(_onProfileFetchedEvent);
    on<AuthLogOutEvent>(_onLogOutEvent);
  }

  final LogInUseCase _logInUseCase;
  final LogOutUseCase _logOutUseCase;
  final FetchUserProfileUseCase _fetchUserProfileUseCase;

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
