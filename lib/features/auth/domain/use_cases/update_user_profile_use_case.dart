import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UpdateUserProfileUseCase {
  final AuthRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<Resource<UserProfileResponse>> call({
    required String id,
    required UpdateUserProfileRequest request,
  }) async {
    final response = await _repository.updateUserProfile(id: id, body: request);
    return response;
  }
}
