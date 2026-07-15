import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_period_detail_use_case.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_settlement_config_use_case.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_settlement_payouts_use_case.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_settlement_periods_use_case.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_event.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_state.dart';

@lazySingleton
class VendorFinanceReconciliationBloc
    extends
        Bloc<
          VendorFinanceReconciliationEvent,
          VendorFinanceReconciliationState
        > {
  final FetchVendorSettlementPeriodUseCase _fetchSettlementPeriodUseCase;
  final FetchVendorPeriodDetailUseCase _fetchPeriodDetailUseCase;

  final FetchVendorSettlementConfigUseCase _fetchSettlementConfigUseCase;
  final FetchVendorSettlementPayoutsUseCase _fetchSettlementPayoutsUseCase;

  VendorFinanceReconciliationBloc(
    this._fetchSettlementPeriodUseCase,
    this._fetchPeriodDetailUseCase,
    this._fetchSettlementConfigUseCase,
    this._fetchSettlementPayoutsUseCase,
  ) : super(
        VendorFinanceReconciliationState(
          settlementPeriodsResource: Resource.success(null),
          periodDetailEntity: Resource.success(null),
          settlementConfigResource: Resource.success(null),
          settlementPayoutsResource: Resource.success(null),
        ),
      ) {
    on<VendorFinanceReconciliationSelectFilterEvent>(_onSelectedFilter);
    on<VendorFinanceReconciliationAddUserIdEvent>(_onAddUserId);

    on<VendorFinanceReconciliationFetchPeriodsEvent>(_onFetchPeriods);
    on<VendorFinanceReconciliationFetchPeriodDetailEvent>(_onFetchPeriodDetail);
    on<VendorFinanceReconciliationChangeSettlementStatusEvent>(
      _onChangeSettlementStatus,
    );

    on<VendorFinanceReconciliationFetchConfigEvent>(_onFetchConfig);
    on<VendorFinanceReconciliationFetchPayoutsEvent>(_onFetchPayouts);
  }

  FutureOr<void> _onSelectedFilter(
    VendorFinanceReconciliationSelectFilterEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) {
    emit(state.copyWith(reconciliationFilter: event.filter));
  }

  FutureOr<void> _onAddUserId(
    VendorFinanceReconciliationAddUserIdEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) {
    emit(state.copyWith(currentUserId: event.userId));
  }

  FutureOr<void> _onFetchPeriods(
    VendorFinanceReconciliationFetchPeriodsEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPeriodsResource: Resource.loading()));

    final response = await _fetchSettlementPeriodUseCase.call(
      userId: state.currentUserId,
    );

    emit(
      state.copyWith(
        settlementPeriodsResource: response,
        periodsData: response.data?.items ?? [],
      ),
    );
  }

  FutureOr<void> _onChangeSettlementStatus(
    VendorFinanceReconciliationChangeSettlementStatusEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPeriodsResource: Resource.loading()));

    final String? status = event.status.name == "all"
        ? null
        : event.status.name;

    final response = await _fetchSettlementPeriodUseCase.call(
      userId: state.currentUserId,
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
    VendorFinanceReconciliationFetchPeriodDetailEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(periodDetailEntity: Resource.loading()));

    final response = await _fetchPeriodDetailUseCase.call(
      userId: event.userId,
      id: event.id,
    );

    emit(state.copyWith(periodDetailEntity: response));
  }

  FutureOr<void> _onFetchConfig(
    VendorFinanceReconciliationFetchConfigEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementConfigResource: Resource.loading()));

    final response = await _fetchSettlementConfigUseCase.call(
      userId: state.currentUserId,
    );

    emit(state.copyWith(settlementConfigResource: response));
  }

  FutureOr<void> _onFetchPayouts(
    VendorFinanceReconciliationFetchPayoutsEvent event,
    Emitter<VendorFinanceReconciliationState> emit,
  ) async {
    emit(state.copyWith(settlementPayoutsResource: Resource.loading()));

    final response = await _fetchSettlementPayoutsUseCase.call(
      userId: state.currentUserId,
    );

    emit(state.copyWith(settlementPayoutsResource: response));
  }

  void initPeriods({required String userId}) {
    add(VendorFinanceReconciliationAddUserIdEvent(userId: userId));
    add(VendorFinanceReconciliationFetchPeriodsEvent());
    add(VendorFinanceReconciliationFetchConfigEvent());
    add(VendorFinanceReconciliationFetchPayoutsEvent());
  }

  void changedFilter(ReconciliationFilter filter) {
    add(VendorFinanceReconciliationSelectFilterEvent(filter: filter));
  }

  void changedSettlementStatus(SettlementStatus status) {
    add(VendorFinanceReconciliationChangeSettlementStatusEvent(status: status));
  }

  void fetchPeriodDetail({required String userId, required String id}) {
    add(
      VendorFinanceReconciliationFetchPeriodDetailEvent(userId: userId, id: id),
    );
  }

  void fetchSettlementPeriods() {
    add(VendorFinanceReconciliationFetchPeriodsEvent());
  }

  void fetchSettlementConfig() {
    add(VendorFinanceReconciliationFetchConfigEvent());
  }
}
