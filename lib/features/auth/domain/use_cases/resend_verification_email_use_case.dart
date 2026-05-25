import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/auth/data/models/request/resend_verification_email_request.dart';
import 'package:oneship_shop/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ResendVerificationEmailUseCase {
  final AuthRepository _repository;

  ResendVerificationEmailUseCase(this._repository);

  Future<Resource> call(ResendVerificationEmailRequest request) async {
    final response = await _repository.resendVerificationEmail(request);
    return response;
  }
}
