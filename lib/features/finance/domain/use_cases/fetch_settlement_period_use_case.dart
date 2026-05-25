import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_shop/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchSettlementPeriodUseCase {
  final FinanceRepository _financeRepository;

  FetchSettlementPeriodUseCase(this._financeRepository);

  Future<Resource<SettlementPeriodsEntity>> call({
    required String shopId,
    int? page,
    int? limit,
    String? status
  }) async {
    final response = await _financeRepository.fetchSettlementPeriods(
      shopId: shopId,
      page: page,
      limit: limit,
      status: status
    );

    return response;
  }
}
