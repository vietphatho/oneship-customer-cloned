import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class RegisterAccountUseCase {
  final AuthRepository _repository;

  RegisterAccountUseCase(this._repository);

  Future<Resource> call(RegisterRequest request) async {
    final response = await _repository.registerAccount(request);
    return response;
  }
}