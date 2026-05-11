import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdateSecondPasswordUseCase {
  final AuthRepository _repository;

  UpdateSecondPasswordUseCase(this._repository);

  Future<Resource> call(Map<String, dynamic> body) {
    return _repository.updateSecondPassword(body);
  }
}
