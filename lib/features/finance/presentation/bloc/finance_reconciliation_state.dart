import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_shop/features/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_shop/features/finance/domain/entities/settlement_payouts_entity.dart';
import 'package:oneship_shop/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_shop/features/finance/enum.dart';

part 'finance_reconciliation_state.freezed.dart';

@freezed
abstract class FinanceReconciliationState with _$FinanceReconciliationState {
  factory FinanceReconciliationState({
    @Default(ReconciliationFilter.period) ReconciliationFilter reconciliationFilter,
    @Default(PeriodStatus.all) PeriodStatus periodStatus,
    @Default("") String currentShopId,

    required Resource<SettlementPeriodsEntity?> settlementPeriodsResource,
    @Default([]) List<PeriodEntity> periodsData,
    required Resource<PeriodDetailEntity?> periodDetailEntity,

    required Resource<SettlementConfigEntity?> settlementConfigResource,
    required Resource<SettlementPayoutsEntity?> settlementPayoutsResource,
  }) = _FinanceReconciliationState;
}
