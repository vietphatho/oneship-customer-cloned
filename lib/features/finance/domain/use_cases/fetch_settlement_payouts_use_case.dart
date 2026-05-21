import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchSettlementPayoutsUseCase {
  final FinanceRepository _financeRepository;

  FetchSettlementPayoutsUseCase(this._financeRepository);

  Future<Resource<SettlementPayoutsEntity>> call({
    required String shopId,
    int? page,
    int? limit,
  }) async {
    final response = await _financeRepository.fetchSettlementPayouts(
      shopId: shopId,
      page: page,
      limit: limit,
    );

    return response;
  }
}
