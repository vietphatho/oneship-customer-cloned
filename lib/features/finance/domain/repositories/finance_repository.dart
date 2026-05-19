import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';

abstract class FinanceRepository extends BaseRepository {
  Future<Resource<FinanceEntity>> fetchShopFinancial({
    required String shopId,
    required String startDate,
    required String endDate,
  });

  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriods({
    required String shopId,
    required int page,
    required int limit,
  });

  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriodsWithStatus({
    required String shopId,
    required int page,
    required int limit,
    required String status,
  });
}
