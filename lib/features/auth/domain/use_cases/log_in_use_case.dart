import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/core/network/token_manager.dart';
import 'package:oneship_shop/features/auth/data/models/request/login_request.dart';
import 'package:oneship_shop/features/auth/data/models/response/login_response.dart';
import 'package:oneship_shop/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LogInUseCase {
  final AuthRepository _repository;
  final TokenManager _tokenManager = TokenManager();

  LogInUseCase(this._repository);

  Future<Resource<LoginResponse>> call(LoginRequest request) async {
    final response = await _repository.login(request);
    if (response.state == Result.success && response.data?.refreshToken != null) {
      _tokenManager.saveTokens(
        accessToken: response.data?.accessToken ?? "",
        refreshToken: response.data?.refreshToken ?? "",
      );
      await Future.delayed(Durations.long2);
    }

    return response;
  }
}
