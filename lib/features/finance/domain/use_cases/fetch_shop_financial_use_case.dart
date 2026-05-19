import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/domain/repositories/finance_repository.dart';

@lazySingleton
class FetchShopFinancialUseCase {
  final FinanceRepository _financeRepository;

  FetchShopFinancialUseCase(this._financeRepository);

  Future<Resource<FinanceEntity>> call({
    required String shopId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _financeRepository.fetchShopFinancial(
      shopId: shopId,
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
