import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/network/token_manager.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_secondary_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/verify_secondary_password_response.dart';
import 'package:oneship_customer/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class VerifySecondaryPasswordUseCase {
  final AuthRepository _repository;
  final TokenManager _tokenManager = TokenManager();

  VerifySecondaryPasswordUseCase(this._repository);

  Future<Resource<VerifySecondaryPasswordResponse>> call(VerifySecondaryPasswordRequest request) async {
    final response = await _repository.verifySecondaryPassword(request);
    if (response.state == Result.success) {
      _tokenManager.saveSecondPasswordToken(
        secondPasswordToken: response.data?.secondPasswordToken ?? ""
      );
      await Future.delayed(Durations.long2);
    }

    return response;
  }
}
