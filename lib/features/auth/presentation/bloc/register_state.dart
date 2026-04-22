import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  factory RegisterState({
    String? email,
    Resource? registerResult,
    Resource? verifyEmailResult,
  }) = _RegisterState;
}
