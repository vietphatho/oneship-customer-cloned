import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';

abstract class FinanceRepository extends BaseRepository {
  Future<Resource<FinanceEntity>> fetchShopFinancial({
    required String shopId,
    required String startDate,
    required String endDate,
  });

  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriods({
    required String shopId,
    int? page,
    int? limit,
    String? status
  });

  Future<Resource<PeriodDetailEntity>> fetchPeriodsDetail({
    required String shopId,
    required String id,
  });

  Future<Resource<SettlementConfigEntity>> fetchSettlementConfig({
    required String shopId,
  });
}
