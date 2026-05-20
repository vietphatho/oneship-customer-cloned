import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchSettlementPeriodUseCase {
  final FinanceRepository _financeRepository;

  FetchSettlementPeriodUseCase(this._financeRepository);

  Future<Resource<SettlementPeriodsEntity>> call({
    required String shopId,
    required int page,
    required int limit,
  }) async {
    final response = await _financeRepository.fetchSettlementPeriods(
      shopId: shopId,
      page: page,
      limit: limit,
    );
    
    return response;
  }
}
