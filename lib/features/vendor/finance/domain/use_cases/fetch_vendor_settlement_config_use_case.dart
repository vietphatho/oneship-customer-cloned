import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchVendorSettlementConfigUseCase {
  final VendorFinanceRepository _vendorFinanceRepository;

  FetchVendorSettlementConfigUseCase(this._vendorFinanceRepository);

  Future<Resource<SettlementConfigEntity>> call({
    required String userId,
    int? page,
    int? limit,
    String? status,
  }) async {
    final response = await _vendorFinanceRepository.fetchSettlementConfig(
      userId: userId,
    );

    return response;
  }
}
