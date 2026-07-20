import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/location_service/domain/use_cases/search_address_use_case.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_form_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/create_shop_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_commodity_types_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_handling_types_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shop_daily_summary_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shop_vendors_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_shops_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_visible_surcharges_use_case.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/get_shipping_service_configs_use_case.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_event.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

@lazySingleton
class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc(
    this._fetchShopDailySummaryUseCase,
    this._fetchShopsUseCase,
    this._createShopUseCase,
    this._searchAddressUseCase,
    this._getShippingServiceConfigsUseCase,
    this._fetchVisibleSurchargesUseCase,
    this._fetchCommodityTypesUseCase,
    this._fetchHandlingTypesUseCase,
    this._fetchShopVendorsUseCase,
  ) : super(
        ShopState(
          dailySummaryResource: Resource.loading(),
          briefShopsResource: Resource.loading(),
          createShopResource: Resource.loading(),
          shopsResource: Resource.loading(),
          shippingServiceTypesResource: Resource.loading(),
          visibleSurchargeGroupsResource: Resource.loading(data: const []),
          commodityTypesResource: Resource.loading(data: const []),
          handlingTypesResource: Resource.loading(data: const []),
          shopVendorsResource: Resource.loading(data: const []),
          promotionsResource: Resource.loading(),
          newsResource: Resource.loading(),
        ),
      ) {
    on<ShopFetchBriefListEvent>(_onFetchBriefShops);
    on<ShopLoadMoreBriefListEvent>(_onLoadMoreBriefShops);
    on<ShopFetchDataEvent>(_onFetchShops);
    on<ShopLoadMoreDataEvent>(_onLoadMoreShops);
    on<ShopFetchDailySummaryEvent>(_onFetchDailySummary);
    on<ShopInitDataEvent>(_onInit);
    on<ShopCreateEvent>(_onCreateShop);
    on<ShopChangeEvent>(_onChangeShopEvent);
    on<ShopChangeDraftSelectedEvent>(_onChangeDraftSelected);
    on<ShopSearchEvent>(_onSearch);
  }

  final FetchShopDailySummaryUseCase _fetchShopDailySummaryUseCase;
  final FetchShopsUseCase _fetchShopsUseCase;
  final CreateShopUseCase _createShopUseCase;
  final SearchAddressUseCase _searchAddressUseCase;
  final GetShippingServiceConfigsUseCase _getShippingServiceConfigsUseCase;
  final FetchVisibleSurchargesUseCase _fetchVisibleSurchargesUseCase;
  final FetchCommodityTypesUseCase _fetchCommodityTypesUseCase;
  final FetchHandlingTypesUseCase _fetchHandlingTypesUseCase;
  final FetchShopVendorsUseCase _fetchShopVendorsUseCase;

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
    final response = await _fetchShopsUseCase.getBriefShops(
      userId: event.userId,
    );
    emit(
      state.copyWith(
        briefShopsResource: response,
        listBriefShops: response.data?.data ?? [],
      ),
    );
  }

  FutureOr<void> _onLoadMoreBriefShops(
    ShopLoadMoreBriefListEvent event,
    Emitter<ShopState> emit,
  ) async {
    var meta = state.briefShopsResource.data?.meta;
    emit(state.copyWith(briefShopsResource: Resource.loading()));

    final response = await _fetchShopsUseCase.getBriefShops(
      userId: state.userId,
      page: (meta?.page ?? 1) + 1,
    );

    List<BriefShopEntity> briefShops = List.from(state.listBriefShops);

    if (response.state == Result.success) {
      briefShops.addAll(response.data?.data ?? []);
    }

    emit(
      state.copyWith(briefShopsResource: response, listBriefShops: briefShops),
    );
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
    //
    emit(
      state.copyWith(
        userId: event.userId,
        briefShopsResource: Resource.loading(),
      ),
    );
    final getShopsResponse = await _fetchShopsUseCase.getBriefShops(
      userId: event.userId,
    );
    emit(
      state.copyWith(
        briefShopsResource: getShopsResponse,
        filteredShops: getShopsResponse.data?.data ?? [],
        listBriefShops: getShopsResponse.data?.data ?? [],
      ),
    );
    emit(
      state.copyWith(
        currentShop: state.approvedBriefShops.firstOrNull,
        draftSelectedShop: state.approvedBriefShops.firstOrNull,
      ),
    );

    String? shopId = state.currentShop?.shopId;
    if (shopId == null) return;

    //
    emit(state.copyWith(dailySummaryResource: Resource.loading()));
    final dailySumResponse = await _fetchShopDailySummaryUseCase.call(shopId);
    emit(state.copyWith(dailySummaryResource: dailySumResponse));

    emit(
      state.copyWith(
        shippingServiceTypesResource: Resource.loading(),
        visibleSurchargeGroupsResource: Resource.loading(
          data: state.visibleSurchargeGroups,
        ),
        commodityTypesResource: Resource.loading(data: state.commodityTypes),
        handlingTypesResource: Resource.loading(data: state.handlingTypes),
        shopVendorsResource: _isMarketShop(state.currentShop)
            ? Resource.loading(data: state.shopVendors)
            : Resource.success(const []),
      ),
    );

    final shippingServicesFuture = _getShippingServiceConfigsUseCase.call(
      shopId: shopId,
    );
    final visibleSurchargesFuture = _fetchVisibleSurchargesUseCase.call(
      shopId: shopId,
    );
    final commodityTypesFuture = _fetchCommodityTypesUseCase.call(
      shopId: shopId,
    );
    final handlingTypesFuture = _fetchHandlingTypesUseCase.call(shopId: shopId);
    final shopVendorsFuture = _fetchShopVendorsIfMarket(state.currentShop);
    final getShippingServices = await shippingServicesFuture;
    final visibleSurcharges = await visibleSurchargesFuture;
    final commodityTypes = await commodityTypesFuture;
    final handlingTypes = await handlingTypesFuture;
    final shopVendors = await shopVendorsFuture;
    emit(
      state.copyWith(
        shippingServiceTypesResource: getShippingServices,
        visibleSurchargeGroupsResource: visibleSurcharges,
        commodityTypesResource: commodityTypes,
        handlingTypesResource: handlingTypes,
        shopVendorsResource: shopVendors,
      ),
    );
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
  ) async {
    emit(
      state.copyWith(currentShop: event.shop, draftSelectedShop: event.shop),
    );

    emit(
      state.copyWith(
        shippingServiceTypesResource: Resource.loading(),
        visibleSurchargeGroupsResource: Resource.loading(
          data: state.visibleSurchargeGroups,
        ),
        commodityTypesResource: Resource.loading(data: state.commodityTypes),
        handlingTypesResource: Resource.loading(data: state.handlingTypes),
        shopVendorsResource: _isMarketShop(event.shop)
            ? Resource.loading(data: state.shopVendors)
            : Resource.success(const []),
      ),
    );

    final shopId = event.shop.shopId ?? "";
    final shippingServicesFuture = _getShippingServiceConfigsUseCase.call(
      shopId: shopId,
    );
    final visibleSurchargesFuture = _fetchVisibleSurchargesUseCase.call(
      shopId: shopId,
    );
    final commodityTypesFuture = _fetchCommodityTypesUseCase.call(
      shopId: shopId,
    );
    final handlingTypesFuture = _fetchHandlingTypesUseCase.call(shopId: shopId);
    final shopVendorsFuture = _fetchShopVendorsIfMarket(event.shop);
    final getShippingServices = await shippingServicesFuture;
    final visibleSurcharges = await visibleSurchargesFuture;
    final commodityTypes = await commodityTypesFuture;
    final handlingTypes = await handlingTypesFuture;
    final shopVendors = await shopVendorsFuture;

    emit(
      state.copyWith(
        shippingServiceTypesResource: getShippingServices,
        visibleSurchargeGroupsResource: visibleSurcharges,
        commodityTypesResource: commodityTypes,
        handlingTypesResource: handlingTypes,
        shopVendorsResource: shopVendors,
      ),
    );
  }

  FutureOr<void> _onChangeDraftSelected(
    ShopChangeDraftSelectedEvent event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copyWith(draftSelectedShop: event.shop));
  }

  void init(String userId) {
    add(ShopInitDataEvent(userId));
    add(ShopFetchDataEvent());
  }

  void fetchBriefShop() {
    add(ShopFetchBriefListEvent(state.userId));
  }

  void loadMoreBriefShop() {
    add(ShopLoadMoreBriefListEvent());
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

  void changeDraftSelectedShop(BriefShopEntity shop) {
    add(ShopChangeDraftSelectedEvent(shop));
  }

  void searchShops(String query) {
    add(ShopSearchEvent(query));
  }

  Future<Resource<ShopVendorEntity>> fetchShopVendor({
    required String shopId,
    required String vendorId,
  }) {
    return _fetchShopsUseCase.fetchShopVendor(
      shopId: shopId,
      vendorId: vendorId,
    );
  }

  Future<Resource<List<ShopVendorEntity>>> _fetchShopVendorsIfMarket(
    BriefShopEntity? shop,
  ) {
    final shopId = shop?.shopId;
    if (!_isMarketShop(shop) || shopId == null || shopId.isEmpty) {
      return Future.value(Resource.success(const []));
    }

    return _fetchShopVendorsUseCase.call(shopId: shopId, limit: 100);
  }

  bool _isMarketShop(BriefShopEntity? shop) {
    return shop?.shopType == ShopType.market;
  }

  FutureOr<void> _onSearch(ShopSearchEvent event, Emitter<ShopState> emit) {
    final allShops = state.briefShopsResource.data?.data ?? [];
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
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
