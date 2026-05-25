import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_shop/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class CreateSecondPasswordUseCase {
  final AuthRepository _repository;

  CreateSecondPasswordUseCase(this._repository);

  Future<Resource> call(CreateSecondPasswordRequest body) {
    return _repository.createSecondPassword(body);
  }
}
