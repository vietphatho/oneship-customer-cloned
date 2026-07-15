import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchVendorPeriodDetailUseCase {
  final VendorFinanceRepository _vendorFinanceRepository;

  FetchVendorPeriodDetailUseCase(this._vendorFinanceRepository);

  Future<Resource<PeriodDetailEntity>> call({
    required String userId,
    required String id,
  }) async {
    final response = await _vendorFinanceRepository.fetchPeriodsDetail(
      userId: userId,
      id: id,
    );

    return response;
  }
}
