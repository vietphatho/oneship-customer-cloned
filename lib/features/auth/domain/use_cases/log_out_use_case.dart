import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/network/token_manager.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LogOutUseCase {
  final TokenManager _tokenManager = TokenManager();
  final AuthRepository _repository;

  LogOutUseCase(this._repository);

  Future<Resource> call() async {
    final response = await _repository.logout();
    if(response.state == Result.success) {
      _tokenManager.clearTokens();
    }
    return response;
  }
}
