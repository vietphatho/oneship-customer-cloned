import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdateUserAvatarUseCase {
  final AuthRepository _repository;

  UpdateUserAvatarUseCase(this._repository);

  Future<Resource> call({
    required String id,
    required String avatarPath,
  }) async {
    return _repository.updateUserAvatar(id: id, avatarPath: avatarPath);
  }
}
