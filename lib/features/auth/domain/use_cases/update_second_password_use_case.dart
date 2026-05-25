import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/auth/data/models/request/update_second_password_request.dart';
import 'package:oneship_shop/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdateSecondPasswordUseCase {
  final AuthRepository _repository;

  UpdateSecondPasswordUseCase(this._repository);

  Future<Resource> call(UpdateSecondPasswordRequest body) {
    return _repository.updateSecondPassword(body);
  }
}
