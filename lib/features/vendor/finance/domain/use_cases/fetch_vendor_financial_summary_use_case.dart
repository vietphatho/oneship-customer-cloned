import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchVendorFinancialSummaryUseCase {
  final VendorFinanceRepository _vendorFinanceRepository;

  FetchVendorFinancialSummaryUseCase(this._vendorFinanceRepository);

  Future<Resource<VendorFinanceEntity>> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _vendorFinanceRepository.fetchVendorFinancialSummary(
      userId: userId,
      startDate: DateTimeUtils.formatDateTime(
        startDate,
        format: Constants.requestDateFormat,
      )!,
      endDate: DateTimeUtils.formatDateTime(
        endDate,
        format: Constants.requestDateFormat,
      )!,
    );
    return response;
  }
}
