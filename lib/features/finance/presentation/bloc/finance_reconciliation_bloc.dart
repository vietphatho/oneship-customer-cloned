import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_config_use_case.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_settlement_payouts_use_case.dart';
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
  final FetchSettlementPayoutsUseCase _fetchSettlementPayoutsUseCase;

  FinanceReconciliationBloc(
    this._fetchSettlementPeriodUseCase,
    this._fetchPeriodDetailUseCase,
    this._fetchSettlementConfigUseCase,
    this._fetchSettlementPayoutsUseCase,
  ) : super(
        FinanceReconciliationState(
          settlementPeriodsResource: Resource.success(null),
          periodDetailEntity: Resource.success(null),
          settlementConfigResource: Resource.success(null),
          settlementPayoutsResource: Resource.success(null),
        ),
      ) {
    on<FinanceReconciliationSelectFilterEvent>(_onSelectedFilter);
    on<FinanceReconciliationAddShopIdEvent>(_onAddShopId);

    on<FinanceReconciliationFetchPeriodsEvent>(_onFetchPeriods);
    on<FinanceReconciliationFetchPeriodDetailEvent>(_onFetchPeriodDetail);
    on<FinanceReconciliationChangePeriodStatusEvent>(_onChangePeriodStatus);

    on<FinanceReconciliationFetchConfigEvent>(_onFetchConfig);
    on<FinanceReconciliationFetchPayoutsEvent>(_onFetchPayouts);
  }

  FutureOr<void> _onSelectedFilter(
    FinanceReconciliationSelectFilterEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) {
    emit(state.copyWith(reconciliationFilter: event.filter));
  }

  FutureOr<void> _onAddShopId(
    FinanceReconciliationAddShopIdEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) {
    emit(state.copyWith(currentShopId: event.shopId));
  }

  FutureOr<void> _onFetchPeriods(
    FinanceReconciliationFetchPeriodsEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPeriodsResource: Resource.loading()));

    final response = await _fetchSettlementPeriodUseCase.call(
      shopId: state.currentShopId,
    );

    emit(
      state.copyWith(
        settlementPeriodsResource: response,
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
      shopId: state.currentShopId,
    );

    emit(state.copyWith(settlementConfigResource: response));
  }

  FutureOr<void> _onFetchPayouts(
    FinanceReconciliationFetchPayoutsEvent event,
    Emitter<FinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPayoutsResource: Resource.loading()));

    final response = await _fetchSettlementPayoutsUseCase.call(
      shopId: state.currentShopId,
    );

    emit(state.copyWith(settlementPayoutsResource: response));
  }

  void initPeriods({required String shopId}) {
    add(FinanceReconciliationAddShopIdEvent(shopId: shopId));
    add(FinanceReconciliationFetchPeriodsEvent());
    add(FinanceReconciliationFetchConfigEvent());
    add(FinanceReconciliationFetchPayoutsEvent());
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

  void fetchSettlementPeriods() {
    add(FinanceReconciliationFetchPeriodsEvent());
  }

  void fetchSettlementConfig() {
    add(FinanceReconciliationFetchConfigEvent());
  }
}
