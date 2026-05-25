import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/auth/data/models/request/update_password_request.dart';
import 'package:oneship_shop/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdatePasswordUseCase {
  final AuthRepository _repository;

  UpdatePasswordUseCase(this._repository);

  Future<Resource> call(UpdatePasswordRequest body) {
    return _repository.updatePassword(body);
  }
}
