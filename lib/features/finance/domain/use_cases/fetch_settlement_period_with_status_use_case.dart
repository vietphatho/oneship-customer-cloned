import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchSettlementPeriodWithStatusUseCase {
  final FinanceRepository _financeRepository;

  FetchSettlementPeriodWithStatusUseCase(this._financeRepository);

  Future<Resource<SettlementPeriodsEntity>> call({
    required String shopId,
    required int page,
    required int limit,
    required String status,
  }) async {
    final response = await _financeRepository.fetchSettlementPeriodsWithStatus(
      shopId: shopId,
      page: page,
      limit: limit,
      status: status,
    );
    
    return response;
  }
}
