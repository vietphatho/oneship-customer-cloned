import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_financial_summary_use_case.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_overview_event.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_overview_state.dart';

@lazySingleton
class VendorFinanceOverviewBloc
    extends Bloc<VendorFinanceOverviewEvent, VendorFinanceOverviewState> {
  final FetchVendorFinancialSummaryUseCase _fetchVendorFinancialSummaryUseCase;

  VendorFinanceOverviewBloc(this._fetchVendorFinancialSummaryUseCase)
    : super(_initialState()) {
    on<VendorFinanceOverviewSelectFilterEvent>(_onSelectedFilter);
    on<VendorFinanceOverviewFetchDataEvent>(_onFetchFinancialData);
  }

  static VendorFinanceOverviewState _initialState() {
    final initialFilter = VendorFinanceFilter.thirtyDay;
    final now = DateTime.now();
    final startDate = initialFilter.getStartDate()!;
    final endDate = DateTime(now.year, now.month, now.day);

    return VendorFinanceOverviewState(
      financeFilter: initialFilter,
      startDate: startDate,
      endDate: endDate,
      vendorFinancialData: Resource.success(VendorFinanceEntity()),
    );
  }

  FutureOr<void> _onSelectedFilter(
    VendorFinanceOverviewSelectFilterEvent event,
    Emitter<VendorFinanceOverviewState> emit,
  ) {
    emit(
      state.copyWith(
        financeFilter: event.filter,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
  }

  FutureOr<void> _onFetchFinancialData(
    VendorFinanceOverviewFetchDataEvent event,
    Emitter<VendorFinanceOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        vendorFinancialData: Resource.loading(
          data: state.vendorFinancialData.data,
        ),
        requestSource: event.requestSource,
      ),
    );

    final response = await _fetchVendorFinancialSummaryUseCase.call(
      userId: event.userId,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    emit(state.copyWith(vendorFinancialData: response));
  }

  void init({
    required String userId,
    required VendorFinanceRequestSource requestSource,
  }) {
    add(
      VendorFinanceOverviewFetchDataEvent(
        userId: userId,
        requestSource: requestSource,
      ),
    );
  }

  void fetchFinancialData({
    required VendorFinanceFilter filter,
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
    required VendorFinanceRequestSource requestSource,
  }) {
    add(
      VendorFinanceOverviewSelectFilterEvent(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    add(
      VendorFinanceOverviewFetchDataEvent(
        userId: userId,
        requestSource: requestSource,
      ),
    );
  }
}
