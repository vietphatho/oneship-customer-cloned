import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/domain/use_cases/fetch_shop_financial_use_case.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_event.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_state.dart';

@lazySingleton
class FinanceOverviewBloc
    extends Bloc<FinanceOverviewEvent, FinanceOverviewState> {
  final FetchShopFinancialUseCase _fetchShopFinancialUseCase;

  FinanceOverviewBloc(this._fetchShopFinancialUseCase)
    : super(_initialState()) {
    on<FinanceOverviewSelectFilterEvent>(_onSelectedFilter);
    on<FinanceOverviewFetchDataEvent>(_onFetchFinancialData);
  }

  static FinanceOverviewState _initialState() {
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, now.day - 1);
    final endDate = DateTime(now.year, now.month, now.day);

    return FinanceOverviewState(
      startDate: startDate,
      endDate: endDate,
      shopFinancialData: Resource.success(FinanceEntity()),
    );
  }

  FutureOr<void> _onSelectedFilter(
    FinanceOverviewSelectFilterEvent event,
    Emitter<FinanceOverviewState> emit,
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
    FinanceOverviewFetchDataEvent event,
    Emitter<FinanceOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        shopFinancialData: Resource.loading(data: state.shopFinancialData.data),
        requestSource: event.requestSource,
      ),
    );

    final response = await _fetchShopFinancialUseCase.call(
      shopId: event.shopId,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    emit(state.copyWith(shopFinancialData: response));
  }

  void init({
    required String shopId,
    required FinanceRequestSource requestSource,
  }) {
    add(
      FinanceOverviewFetchDataEvent(
        shopId: shopId,
        requestSource: requestSource,
      ),
    );
  }

  void fetchFinancialData({
    required FinanceFilter filter,
    required DateTime startDate,
    required DateTime endDate,
    required String shopId,
    required FinanceRequestSource requestSource,
  }) {
    add(
      FinanceOverviewSelectFilterEvent(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    add(
      FinanceOverviewFetchDataEvent(
        shopId: shopId,
        requestSource: requestSource,
      ),
    );
  }
}
