import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchVendorSettlementPeriodUseCase {
  final VendorFinanceRepository _vendorFinanceRepository;

  FetchVendorSettlementPeriodUseCase(this._vendorFinanceRepository);

  Future<Resource<SettlementPeriodsEntity>> call({
    required String userId,
    int? page,
    int? limit,
    String? status,
  }) async {
    final response = await _vendorFinanceRepository.fetchSettlementPeriods(
      userId: userId,
      page: page,
      limit: limit,
      status: status,
    );

    return response;
  }
}
