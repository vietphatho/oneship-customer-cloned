import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class FetchUserProfileUseCase {
  final AuthRepository _repository;

  FetchUserProfileUseCase(this._repository);

  Future<Resource<UserProfileResponse>> call() async {
    final response = await _repository.fetchUserProfile();
    return response;
  }
}
