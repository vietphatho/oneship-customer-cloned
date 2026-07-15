import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_periods_entity.dart';

abstract class VendorFinanceRepository extends BaseRepository {
  Future<Resource<VendorFinanceEntity>> fetchVendorFinancialSummary({
    required String userId,
    required String startDate,
    required String endDate,
  });

  Future<Resource<SettlementPeriodsEntity>> fetchSettlementPeriods({
    required String userId,
    int? page,
    int? limit,
    String? status,
  });

  Future<Resource<PeriodDetailEntity>> fetchPeriodsDetail({
    required String userId,
    required String id,
  });

  Future<Resource<SettlementConfigEntity>> fetchSettlementConfig({
    required String userId,
  });

  Future<Resource<SettlementPayoutsEntity>> fetchSettlementPayouts({
    required String userId,
    int? page,
    int? limit,
  });
}
