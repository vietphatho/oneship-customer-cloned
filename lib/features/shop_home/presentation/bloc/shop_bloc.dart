import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shop_daily_summary_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shops_use_case.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_event.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

@lazySingleton
class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc(this._fetchShopDailySummaryUseCase, this._fetchShopsUseCase)
    : super(
        ShopState(
          dailySummaryResource: Resource.loading(),
          shopsResource: Resource.loading(),
        ),
      ) {
    on<ShopFetchListEvent>(_onFetchShops);
    on<ShopFetchDailySummaryEvent>(_onFetchDailySummary);
    on<ShopInitDataEvent>(_onInit);
    on<ShopChangeEvent>(_onChangeShopEvent);
    on<ShopSearchEvent>(_onSearch);
  }

  final FetchShopDailySummaryUseCase _fetchShopDailySummaryUseCase;
  final FetchShopsUseCase _fetchShopsUseCase;

  FutureOr<void> _onFetchDailySummary(
    ShopFetchDailySummaryEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(dailySummaryResource: Resource.loading()));
    final response = await _fetchShopDailySummaryUseCase.call(event.shopId);
    emit(state.copyWith(dailySummaryResource: response));
  }

  FutureOr<void> _onFetchShops(
    ShopFetchListEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(
      state.copyWith(userId: event.userId, shopsResource: Resource.loading()),
    );
    final response = await _fetchShopsUseCase.call(event.userId);
    emit(state.copyWith(shopsResource: response));
  }

  FutureOr<void> _onInit(
    ShopInitDataEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(
      state.copyWith(userId: event.userId, shopsResource: Resource.loading()),
    );
    final getShopsResponse = await _fetchShopsUseCase.call(event.userId);
    emit(
      state.copyWith(
        shopsResource: getShopsResponse,
        filteredShops: getShopsResponse.data?.data ?? [],
        currentShop: getShopsResponse.data?.data.firstOrNull,
      ),
    );

    String? shopId = state.currentShop?.shopId;
    if (shopId == null) return;

    emit(state.copyWith(dailySummaryResource: Resource.loading()));
    final dailySumResponse = await _fetchShopDailySummaryUseCase.call(shopId);
    emit(state.copyWith(dailySummaryResource: dailySumResponse));
  }

  FutureOr<void> _onChangeShopEvent(
    ShopChangeEvent event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copyWith(currentShop: event.shop));
  }

  void init(String userId) {
    add(ShopInitDataEvent(userId));
  }

  void changeShop(ShopEntity shop) {
    add(ShopChangeEvent(shop));
    add(ShopFetchDailySummaryEvent(shop.shopId!));
  }

  void searchShops(String query) {
    add(ShopSearchEvent(query));
  }

  FutureOr<void> _onSearch(
    ShopSearchEvent event,
    Emitter<ShopState> emit,
  ) {
    final allShops = state.shopsResource.data?.data ?? [];
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? allShops
        : allShops
            .where((s) => s.shopName.toLowerCase().contains(query))
            .toList();
    emit(state.copyWith(filteredShops: filtered));
  }
}
