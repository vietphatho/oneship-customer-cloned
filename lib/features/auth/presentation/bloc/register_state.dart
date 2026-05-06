import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  factory RegisterState({
    String? email,
    Resource? registerResult,
    Resource? verifyEmailResult,
    Resource? resendVerificationEmailResult,
  }) = _RegisterState;
}
