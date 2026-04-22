import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_email_request.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/register_account_use_case.dart';
import 'package:oneship_customer/features/auth/domain/use_cases/verify_email_use_case.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_event.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_state.dart';

@lazySingleton
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterAccountUseCase _registerAccountUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;

  RegisterBloc(this._registerAccountUseCase, this._verifyEmailUseCase)
    : super(RegisterState()) {
    on<RegisterRequestEvent>(_onRegisterRequestEvent);
    on<RegisterVerifyEmailEvent>(_onRegisterVerifyEmailEvent);
  }

  Future<void> _onRegisterRequestEvent(
    RegisterRequestEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(registerResult: Resource.loading()));

    final response = await _registerAccountUseCase.call(event.request);

    emit(state.copyWith(registerResult: response, email: event.request.userEmail));
  }

  Future<void> _onRegisterVerifyEmailEvent(
    RegisterVerifyEmailEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(verifyEmailResult: Resource.loading()));

    final response = await _verifyEmailUseCase.call(event.request);

    emit(state.copyWith(verifyEmailResult: response));
  }

  void registerRequest({
    required String userLogin,
    required String displayName,
    required String userEmail,
    required String userPhone,
    required String userPass,
    required String roleName,
  }) {
    final request = RegisterRequest(
      userLogin: userLogin,
      displayName: displayName,
      userEmail: userEmail,
      userPhone: userPhone,
      userPass: userPass,
      roleName: roleName,
    );
    add(RegisterRequestEvent(request));
  }

  void verifyEmailRequest({required String code, required String email}) {
    final request = VerifyEmailRequest(code: code, email: email);
    add(RegisterVerifyEmailEvent(request));
  }
}
