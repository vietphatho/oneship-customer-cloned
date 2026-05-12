import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/location_service/domain/use_cases/search_address_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_form_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/create_shop_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shop_daily_summary_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shops_use_case.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_event.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

@lazySingleton
class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc(
    this._fetchShopDailySummaryUseCase,
    this._fetchShopsUseCase,
    this._createShopUseCase,
    this._searchAddressUseCase,
  ) : super(
        ShopState(
          dailySummaryResource: Resource.loading(),
          briefShopsResource: Resource.loading(),
          createShopResource: Resource.loading(),
          shopsResource: Resource.loading(),
        ),
      ) {
    on<ShopFetchBriefListEvent>(_onFetchBriefShops);
    on<ShopFetchDataEvent>(_onFetchShops);
    on<ShopLoadMoreDataEvent>(_onLoadMoreShops);
    on<ShopFetchDailySummaryEvent>(_onFetchDailySummary);
    on<ShopInitDataEvent>(_onInit);
    on<ShopCreateEvent>(_onCreateShop);
    on<ShopChangeEvent>(_onChangeShopEvent);
    on<ShopSearchEvent>(_onSearch);
  }

  final FetchShopDailySummaryUseCase _fetchShopDailySummaryUseCase;
  final FetchShopsUseCase _fetchShopsUseCase;
  final CreateShopUseCase _createShopUseCase;
  final SearchAddressUseCase _searchAddressUseCase;

  FutureOr<void> _onFetchDailySummary(
    ShopFetchDailySummaryEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(dailySummaryResource: Resource.loading()));
    final response = await _fetchShopDailySummaryUseCase.call(event.shopId);
    emit(state.copyWith(dailySummaryResource: response));
  }

  FutureOr<void> _onFetchBriefShops(
    ShopFetchBriefListEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(
      state.copyWith(
        userId: event.userId,
        briefShopsResource: Resource.loading(),
      ),
    );
    final response = await _fetchShopsUseCase.getBriefShops(event.userId);
    emit(state.copyWith(briefShopsResource: response));
  }

  FutureOr<void> _onFetchShops(
    ShopFetchDataEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(shopsResource: Resource.loading()));
    final response = await _fetchShopsUseCase.getShops();
    emit(state.copyWith(shopsResource: response));
  }

  FutureOr<void> _onLoadMoreShops(
    ShopLoadMoreDataEvent event,
    Emitter<ShopState> emit,
  ) async {
    var shopsData = state.shopsResource.data;

    if (shopsData?.hasMoreData != true) {
      return Future.value();
    }

    final response = await _fetchShopsUseCase.getShops(
      page: shopsData?.meta?.page,
    );
    emit(state.copyWith(shopsResource: response));
  }

  FutureOr<void> _onInit(
    ShopInitDataEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(
      state.copyWith(
        userId: event.userId,
        briefShopsResource: Resource.loading(),
      ),
    );
    final getShopsResponse = await _fetchShopsUseCase.getBriefShops(
      event.userId,
    );
    emit(
      state.copyWith(
        briefShopsResource: getShopsResponse,
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

  FutureOr<void> _onCreateShop(
    ShopCreateEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(createShopResource: Resource.loading()));
    final response = await _createShopUseCase.call(event.params);
    emit(state.copyWith(createShopResource: response));
  }

  FutureOr<void> _onChangeShopEvent(
    ShopChangeEvent event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copyWith(currentShop: event.shop));
  }

  void init(String userId) {
    add(ShopInitDataEvent(userId));
    add(ShopFetchDataEvent());
  }

  void fetchShop() {
    add(ShopFetchDataEvent());
  }

  void loadMore() {
    add(ShopLoadMoreDataEvent());
  }

  void submitCreateShopForm(CreateShopFormEntity formValue) {
    add(
      ShopCreateEvent(
        CreateShopParams(
          userId: state.userId,
          shopName: formValue.shopName,
          phone: formValue.phoneNumber,
          email: formValue.contactEmail,
          fullAddress: formValue.fullAddress,
          provinceCode: formValue.provinceCode,
          provinceName: formValue.provinceName,
          wardCode: formValue.wardCode,
          wardName: formValue.wardName,
          vietMapRefId: formValue.vietMapRefId,
        ),
      ),
    );
  }

  void changeShop(BriefShopEntity shop) {
    add(ShopChangeEvent(shop));
    add(ShopFetchDailySummaryEvent(shop.shopId!));
  }

  void searchShops(String query) {
    add(ShopSearchEvent(query));
  }

  FutureOr<void> _onSearch(ShopSearchEvent event, Emitter<ShopState> emit) {
    final allShops = state.briefShopsResource.data?.data ?? [];
    final query = event.query.trim().toLowerCase();
    final filtered =
        query.isEmpty
            ? allShops
            : allShops
                .where((s) => s.shopName.toLowerCase().contains(query))
                .toList();
    emit(state.copyWith(filteredShops: filtered));
  }

  Future<List<SuggestedAddressResponse>> searchAddress({
    required Province province,
    required Ward ward,
    required String keyword,
  }) async {
    final resource = await _searchAddressUseCase.call(
      provinceName: province.name,
      provinceCode: province.code,
      wardName: ward.name,
      wardCode: ward.code,
      keyword: keyword,
    );
    return resource.data ?? [];
  }
}
