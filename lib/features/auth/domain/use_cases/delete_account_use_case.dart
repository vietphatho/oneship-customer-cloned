import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<Resource> call() {
    return _repository.deleteAccount();
  }
}
