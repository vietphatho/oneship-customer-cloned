import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/enum.dart';

part 'finance_reconciliation_state.freezed.dart';

@freezed
abstract class FinanceReconciliationState with _$FinanceReconciliationState {
  factory FinanceReconciliationState({
    @Default(ReconciliationFilter.periods) ReconciliationFilter reconciliationFilter,
    @Default(1) int page,
    @Default(10) int limit,
    required Resource<SettlementPeriodsEntity> settlementPeriods,
  }) = _FinanceReconciliationState;
}
