import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_period_use_case.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_period_with_status_use_case.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_event.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';

@lazySingleton
class FinanceReconciliationBloc
    extends Bloc<FinanceReconciliationEvent, FinanceReconciliationState> {
  final FetchSettlementPeriodUseCase _fetchSettlementPeriodUseCase;
  final FetchSettlementPeriodWithStatusUseCase
  _fetchSettlementPeriodWithStatusUseCase;

  FinanceReconciliationBloc(
    this._fetchSettlementPeriodUseCase,
    this._fetchSettlementPeriodWithStatusUseCase,
  ) : super(
        FinanceReconciliationState(
          settlementPeriods: Resource.success(SettlementPeriodsEntity()),
        ),
      ) {
    on<FinanceReconciliationSelectFilterEvent>(_onSelectedFilter);
    on<FinanceReconciliationFetchPeriodsEvent>(_onFetchPeriods);
  }

  FutureOr<void> _onSelectedFilter(
    FinanceReconciliationSelectFilterEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) {
    emit(state.copyWith(reconciliationFilter: event.filter));
  }

  FutureOr<void> _onFetchPeriods(
    FinanceReconciliationFetchPeriodsEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPeriods: Resource.loading()));

    final response = await _fetchSettlementPeriodUseCase.call(
      shopId: event.shopId,
      page: state.page,
      limit: state.limit,
    );

    emit(state.copyWith(settlementPeriods: response));
  }

  void initPeriods({required String shopId}) {
    add(FinanceReconciliationFetchPeriodsEvent(shopId: shopId));
  }

  void changedFilter(ReconciliationFilter filter) {
    add(FinanceReconciliationSelectFilterEvent(filter: filter));
  }
}
