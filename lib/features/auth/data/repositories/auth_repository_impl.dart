import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/datasources/auth_api.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/login_response.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<Resource<LoginResponse>> login(LoginRequest body) async {
    return request<LoginResponse, BaseError>(() => _authApi.login(body));
  }

  @override
  Future<Resource<UserProfileResponse>> fetchUserProfile() {
    return request<UserProfileResponse, BaseError>(
      () => _authApi.fetchUserProfile(),
    );
  }

  @override
  Future<Resource> registerAccount(RegisterRequest body) {
    return request(() => _authApi.registerAccount(body));
  }
}
