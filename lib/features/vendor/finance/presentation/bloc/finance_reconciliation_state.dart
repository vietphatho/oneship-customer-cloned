import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';

part 'finance_reconciliation_state.freezed.dart';

@freezed
abstract class VendorFinanceReconciliationState
    with _$VendorFinanceReconciliationState {
  factory VendorFinanceReconciliationState({
    @Default(ReconciliationFilter.period)
    ReconciliationFilter reconciliationFilter,
    @Default(SettlementStatus.all) SettlementStatus periodStatus,
    @Default("") String currentUserId,

    required Resource<SettlementPeriodsEntity?> settlementPeriodsResource,
    @Default([]) List<PeriodEntity> periodsData,
    required Resource<PeriodDetailEntity?> periodDetailEntity,

    required Resource<SettlementConfigEntity?> settlementConfigResource,
    required Resource<SettlementPayoutsEntity?> settlementPayoutsResource,
  }) = _VendorFinanceReconciliationState;
}
