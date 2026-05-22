import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchPeriodDetailUseCase {
  final FinanceRepository _financeRepository;

  FetchPeriodDetailUseCase(this._financeRepository);

  Future<Resource<PeriodDetailEntity>> call({
    required String shopId,
    required String id,
  }) async {
    final response = await _financeRepository.fetchPeriodsDetail(
      shopId: shopId,
      id: id,
    );

    return response;
  }
}
