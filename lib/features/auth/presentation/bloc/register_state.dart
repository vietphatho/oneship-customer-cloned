import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';

abstract class RegisterState {
  const RegisterState({required this.request});

  final RegisterRequest request;
}

class RegisterChangeRequestState extends RegisterState {
  RegisterChangeRequestState({required super.request});
}
