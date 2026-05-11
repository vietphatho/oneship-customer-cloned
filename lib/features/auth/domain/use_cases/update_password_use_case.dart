import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdatePasswordUseCase {
  final AuthRepository _repository;

  UpdatePasswordUseCase(this._repository);

  Future<Resource> call(Map<String, dynamic> body) {
    return _repository.updatePassword(body);
  }
}
