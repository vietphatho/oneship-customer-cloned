import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_config_use_case.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_period_use_case.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_period_detail_use_case.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_event.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';

@lazySingleton
class FinanceReconciliationBloc
    extends Bloc<FinanceReconciliationEvent, FinanceReconciliationState> {
  final FetchSettlementPeriodUseCase _fetchSettlementPeriodUseCase;
  final FetchPeriodDetailUseCase _fetchPeriodDetailUseCase;

  final FetchSettlementConfigUseCase _fetchSettlementConfigUseCase;

  FinanceReconciliationBloc(
    this._fetchSettlementPeriodUseCase,
    this._fetchPeriodDetailUseCase,
    this._fetchSettlementConfigUseCase,
  ) : super(
        FinanceReconciliationState(
          settlementPeriodsResource: Resource.success(null),
          periodDetailEntity: Resource.success(null),
          settlementConfigResource: Resource.success(null),
        ),
      ) {
    on<FinanceReconciliationSelectFilterEvent>(_onSelectedFilter);

    on<FinanceReconciliationFetchPeriodsEvent>(_onFetchPeriods);
    on<FinanceReconciliationFetchPeriodDetailEvent>(_onFetchPeriodDetail);
    on<FinanceReconciliationChangePeriodStatusEvent>(_onChangePeriodStatus);

    on<FinanceReconciliationFetchConfigEvent>(_onFetchConfig);
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
    emit(state.copyWith(settlementPeriodsResource: Resource.loading()));

    final response = await _fetchSettlementPeriodUseCase.call(
      shopId: event.shopId,
    );

    emit(
      state.copyWith(
        settlementPeriodsResource: response,
        currentShopId: event.shopId,
        periodsData: response.data?.items ?? [],
      ),
    );
  }

  FutureOr<void> _onChangePeriodStatus(
    FinanceReconciliationChangePeriodStatusEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPeriodsResource: Resource.loading()));

    final String? status =
        event.status.name == "all" ? null : event.status.name;

    final response = await _fetchSettlementPeriodUseCase.call(
      shopId: state.currentShopId,
      status: status,
    );

    emit(
      state.copyWith(
        periodStatus: event.status,
        settlementPeriodsResource: response,
        periodsData: response.data?.items ?? [],
      ),
    );
  }

  FutureOr<void> _onFetchPeriodDetail(
    FinanceReconciliationFetchPeriodDetailEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(periodDetailEntity: Resource.loading()));

    final response = await _fetchPeriodDetailUseCase.call(
      shopId: event.shopId,
      id: event.id,
    );

    emit(state.copyWith(periodDetailEntity: response));
  }

  FutureOr<void> _onFetchConfig(
    FinanceReconciliationFetchConfigEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementConfigResource: Resource.loading()));

    final response = await _fetchSettlementConfigUseCase.call(
      shopId: event.shopId,
    );

    emit(state.copyWith(settlementConfigResource: response));
  }

  void initPeriods({required String shopId}) {
    add(FinanceReconciliationFetchPeriodsEvent(shopId: shopId));
    add(FinanceReconciliationFetchConfigEvent(shopId: shopId));
  }

  void changedFilter(ReconciliationFilter filter) {
    add(FinanceReconciliationSelectFilterEvent(filter: filter));
  }

  void changedPeriodStatus(PeriodStatus status) {
    add(FinanceReconciliationChangePeriodStatusEvent(status: status));
  }

  void fetchPeriodDetail({required String shopId, required String id}) {
    add(FinanceReconciliationFetchPeriodDetailEvent(shopId: shopId, id: id));
  }
}
