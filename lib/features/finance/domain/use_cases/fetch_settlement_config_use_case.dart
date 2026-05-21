import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchSettlementConfigUseCase {
  final FinanceRepository _financeRepository;

  FetchSettlementConfigUseCase(this._financeRepository);

  Future<Resource<SettlementConfigEntity>> call({
    required String shopId,
    int? page,
    int? limit,
    String? status
  }) async {
    final response = await _financeRepository.fetchSettlementConfig(
      shopId: shopId,
    );

    return response;
  }
}
