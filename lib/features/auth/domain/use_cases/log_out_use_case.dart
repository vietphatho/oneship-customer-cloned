import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/network/token_manager.dart';

@lazySingleton
class LogOutUseCase {
  final TokenManager _tokenManager = TokenManager();

  Future<Resource> call() async {
    _tokenManager.clearTokens();
    return Resource.success(null);
  }
}
