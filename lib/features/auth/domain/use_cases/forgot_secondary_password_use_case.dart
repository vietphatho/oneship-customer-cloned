import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/forgot_password_request.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ForgotSecondaryPasswordUseCase {
  final AuthRepository _repository;

  ForgotSecondaryPasswordUseCase(this._repository);

  Future<Resource> call(ForgotPasswordRequest request) {
    return _repository.forgotSecondaryPassword(request);
  }
}
