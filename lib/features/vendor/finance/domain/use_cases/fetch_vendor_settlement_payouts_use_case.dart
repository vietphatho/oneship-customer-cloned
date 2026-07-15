import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchVendorSettlementPayoutsUseCase {
  final VendorFinanceRepository _vendorFinanceRepository;

  FetchVendorSettlementPayoutsUseCase(this._vendorFinanceRepository);

  Future<Resource<SettlementPayoutsEntity>> call({
    required String userId,
    int? page,
    int? limit,
  }) async {
    final response = await _vendorFinanceRepository.fetchSettlementPayouts(
      userId: userId,
      page: page,
      limit: limit,
    );

    return response;
  }
}
