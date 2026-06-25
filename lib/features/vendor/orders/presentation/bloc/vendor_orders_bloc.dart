import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/get_shipper_info_use_case.dart';
import 'package:oneship_customer/features/vendor/orders/data/constants/vendor_orders_request_defaults.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/use_cases/fetch_vendor_archived_order_detail_use_case.dart';
import 'package:oneship_customer/features/vendor/orders/domain/use_cases/fetch_vendor_archived_orders_use_case.dart';
import 'package:oneship_customer/features/vendor/orders/domain/use_cases/fetch_vendor_order_detail_use_case.dart';
import 'package:oneship_customer/features/vendor/orders/domain/use_cases/fetch_vendor_processing_orders_use_case.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_event.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_state.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

@lazySingleton
class VendorOrdersBloc extends Bloc<VendorOrdersEvent, VendorOrdersState> {
  VendorOrdersBloc(
    this._fetchProcessingOrdersUseCase,
    this._fetchArchivedOrdersUseCase,
    this._fetchOrderDetailUseCase,
    this._fetchArchivedOrderDetailUseCase,
    this._getShipperInfoUseCase,
    this._vendorProfileBloc,
  ) : super(VendorOrdersState.initial()) {
    on<VendorOrdersInitEvent>(_onInit);
    on<VendorOrdersFetchedEvent>(_onFetchOrders);
    on<VendorOrdersKeywordChangedEvent>(_onKeywordChanged);
    on<VendorOrderDetailFetchedEvent>(_onFetchOrderDetail);
  }

  static const _searchDebounce = Duration(milliseconds: 500);

  final FetchVendorProcessingOrdersUseCase _fetchProcessingOrdersUseCase;
  final FetchVendorArchivedOrdersUseCase _fetchArchivedOrdersUseCase;
  final FetchVendorOrderDetailUseCase _fetchOrderDetailUseCase;
  final FetchVendorArchivedOrderDetailUseCase _fetchArchivedOrderDetailUseCase;
  final GetShipperInfoUseCase _getShipperInfoUseCase;
  final VendorProfileBloc _vendorProfileBloc;
  final Map<VendorOrdersTab, Timer?> _searchDebounceTimers = {};

  FutureOr<void> _onInit(
    VendorOrdersInitEvent event,
    Emitter<VendorOrdersState> emit,
  ) async {
    final owner = await _ownerOrNull();
    if (owner == null) {
      emit(
        state.copyWith(
          processingOrdersResource: Resource.error(
            'vendor_profile_not_loaded',
            0,
          ),
          archivedOrdersResource: Resource.error(
            'vendor_profile_not_loaded',
            0,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        processingPage: VendorOrdersRequestDefaults.page,
        archivedPage: VendorOrdersRequestDefaults.page,
        processingOrders: [],
        archivedOrders: [],
        processingOrdersResource: Resource.loading(),
        archivedOrdersResource: Resource.loading(),
      ),
    );

    final responses = await Future.wait([
      _fetchProcessingOrdersUseCase(
        shopId: owner.shopId,
        vendorId: owner.vendorId,
        page: VendorOrdersRequestDefaults.page,
        limit: VendorOrdersRequestDefaults.limit,
        trackingCode: _trackingCodeOrNull(state.processingKeyword),
      ),
      _fetchArchivedOrdersUseCase(
        shopId: owner.shopId,
        vendorId: owner.vendorId,
        page: VendorOrdersRequestDefaults.page,
        limit: VendorOrdersRequestDefaults.limit,
        trackingCode: _trackingCodeOrNull(state.archivedKeyword),
      ),
    ]);

    final processingResponse = responses[0];
    final archivedResponse = responses[1];

    emit(
      state.copyWith(
        processingPage: VendorOrdersRequestDefaults.page,
        archivedPage: VendorOrdersRequestDefaults.page,
        processingOrdersResource: processingResponse,
        archivedOrdersResource: archivedResponse,
        processingOrders: _ordersOrEmpty(processingResponse),
        archivedOrders: _ordersOrEmpty(archivedResponse),
      ),
    );
  }

  FutureOr<void> _onFetchOrders(
    VendorOrdersFetchedEvent event,
    Emitter<VendorOrdersState> emit,
  ) async {
    switch (event.tab) {
      case VendorOrdersTab.processing:
        await _fetchProcessingOrders(
          emit,
          reset: event.reset,
          loadMore: event.loadMore,
        );
        break;
      case VendorOrdersTab.archived:
        await _fetchArchivedOrders(
          emit,
          reset: event.reset,
          loadMore: event.loadMore,
        );
        break;
    }
  }

  FutureOr<void> _onKeywordChanged(
    VendorOrdersKeywordChangedEvent event,
    Emitter<VendorOrdersState> emit,
  ) {
    final keyword = event.keyword.trim();

    switch (event.tab) {
      case VendorOrdersTab.processing:
        emit(state.copyWith(processingKeyword: keyword, processingPage: 1));
        break;
      case VendorOrdersTab.archived:
        emit(state.copyWith(archivedKeyword: keyword, archivedPage: 1));
        break;
    }

    _searchDebounceTimers[event.tab]?.cancel();
    _searchDebounceTimers[event.tab] = Timer(_searchDebounce, () {
      add(VendorOrdersFetchedEvent(event.tab, reset: true));
    });
  }

  FutureOr<void> _onFetchOrderDetail(
    VendorOrderDetailFetchedEvent event,
    Emitter<VendorOrdersState> emit,
  ) async {
    final orderId = event.orderId.trim();
    if (orderId.isEmpty) return;
    if (state.isOrderDetailLoading && state.selectedOrderId == orderId) return;

    emit(
      state.copyWith(
        selectedOrderId: orderId,
        selectedOrderTab: event.tab,
        orderDetailResource: Resource.loading(
          data: state.orderDetailResource.data,
        ),
      ),
    );

    final owner = await _ownerOrNull();
    if (owner == null) {
      emit(
        state.copyWith(
          orderDetailResource: Resource.error('vendor_profile_not_loaded', 0),
        ),
      );
      return;
    }

    final response = switch (event.tab) {
      VendorOrdersTab.processing => await _fetchOrderDetailUseCase(
        shopId: owner.shopId,
        vendorId: owner.vendorId,
        orderId: orderId,
      ),
      VendorOrdersTab.archived => await _fetchArchivedOrderDetailUseCase(
        shopId: owner.shopId,
        vendorId: owner.vendorId,
        orderId: orderId,
      ),
    };

    final orderDetail = response.data;
    if (response.state == Result.success &&
        orderDetail != null &&
        orderDetail.shipperCodes.isNotEmpty) {
      final shipperResponse = await _getShipperInfoUseCase(
        orderDetail.shipperCodes.first,
      );
      emit(
        state.copyWith(
          orderDetailResource: response.copyWith(
            data: orderDetail.copyWith(shipper: shipperResponse.data),
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(orderDetailResource: response));
  }

  Future<void> _fetchProcessingOrders(
    Emitter<VendorOrdersState> emit, {
    bool reset = false,
    bool loadMore = false,
  }) async {
    if (state.processingOrdersResource.state == Result.loading) return;
    if (loadMore && !state.hasMoreProcessingOrders) return;

    final previousPage = state.processingPage;
    final page = loadMore
        ? state.processingPage + 1
        : VendorOrdersRequestDefaults.page;

    emit(
      state.copyWith(
        processingPage: page,
        processingOrders: reset ? [] : state.processingOrders,
        processingOrdersResource: Resource.loading(
          data: reset ? null : state.processingOrdersResource.data,
        ),
      ),
    );

    final owner = await _ownerOrNull();
    if (owner == null) {
      emit(
        state.copyWith(
          processingOrdersResource: Resource.error(
            'vendor_profile_not_loaded',
            0,
          ),
        ),
      );
      return;
    }

    final response = await _fetchProcessingOrdersUseCase(
      shopId: owner.shopId,
      vendorId: owner.vendorId,
      page: page,
      limit: VendorOrdersRequestDefaults.limit,
      trackingCode: _trackingCodeOrNull(state.processingKeyword),
    );

    final nextOrders = _resolveOrders(
      response: response,
      current: reset ? [] : state.processingOrders,
      append: loadMore,
    );

    emit(
      state.copyWith(
        processingPage: _pageOrCurrent(
          response,
          loadMore ? previousPage : page,
        ),
        processingOrdersResource: response,
        processingOrders: nextOrders,
      ),
    );
  }

  Future<void> _fetchArchivedOrders(
    Emitter<VendorOrdersState> emit, {
    bool reset = false,
    bool loadMore = false,
  }) async {
    if (state.archivedOrdersResource.state == Result.loading) return;
    if (loadMore && !state.hasMoreArchivedOrders) return;

    final previousPage = state.archivedPage;
    final page = loadMore
        ? state.archivedPage + 1
        : VendorOrdersRequestDefaults.page;

    emit(
      state.copyWith(
        archivedPage: page,
        archivedOrders: reset ? [] : state.archivedOrders,
        archivedOrdersResource: Resource.loading(
          data: reset ? null : state.archivedOrdersResource.data,
        ),
      ),
    );

    final owner = await _ownerOrNull();
    if (owner == null) {
      emit(
        state.copyWith(
          archivedOrdersResource: Resource.error(
            'vendor_profile_not_loaded',
            0,
          ),
        ),
      );
      return;
    }

    final response = await _fetchArchivedOrdersUseCase(
      shopId: owner.shopId,
      vendorId: owner.vendorId,
      page: page,
      limit: VendorOrdersRequestDefaults.limit,
      trackingCode: _trackingCodeOrNull(state.archivedKeyword),
    );

    final nextOrders = _resolveOrders(
      response: response,
      current: reset ? [] : state.archivedOrders,
      append: loadMore,
    );

    emit(
      state.copyWith(
        archivedPage: _pageOrCurrent(response, loadMore ? previousPage : page),
        archivedOrdersResource: response,
        archivedOrders: nextOrders,
      ),
    );
  }

  List<VendorOrderEntity> _ordersOrEmpty(
    Resource<VendorOrdersEntity> response,
  ) {
    if (response.state != Result.success) return [];
    return response.data?.items ?? [];
  }

  List<VendorOrderEntity> _resolveOrders({
    required Resource<VendorOrdersEntity> response,
    required List<VendorOrderEntity> current,
    required bool append,
  }) {
    if (response.state != Result.success) return current;

    final items = response.data?.items ?? [];
    if (!append) return items;
    return [...current, ...items];
  }

  int _pageOrCurrent(Resource<VendorOrdersEntity> response, int current) {
    if (response.state != Result.success) return current;
    return response.data?.meta?.page ?? current;
  }

  String? _trackingCodeOrNull(String keyword) {
    return keyword.trim().isEmpty ? null : keyword.trim();
  }

  Future<_VendorOrdersOwner?> _ownerOrNull() async {
    var profile = _vendorProfileBloc.profile;
    if (profile == null) {
      _vendorProfileBloc.init();
      profile = await _vendorProfileBloc.stream
          .firstWhere((state) => !state.isLoading)
          .then((state) => state.profile);
    }

    final shopId = profile?.shopId?.trim();
    final vendorId = profile?.id?.trim();
    if (shopId == null ||
        shopId.isEmpty ||
        vendorId == null ||
        vendorId.isEmpty) {
      return null;
    }

    return _VendorOrdersOwner(shopId: shopId, vendorId: vendorId);
  }

  void init() {
    add(const VendorOrdersInitEvent());
  }

  void searchProcessingOrders(String keyword) {
    add(
      VendorOrdersKeywordChangedEvent(
        tab: VendorOrdersTab.processing,
        keyword: keyword,
      ),
    );
  }

  void searchArchivedOrders(String keyword) {
    add(
      VendorOrdersKeywordChangedEvent(
        tab: VendorOrdersTab.archived,
        keyword: keyword,
      ),
    );
  }

  void retryProcessingOrders() {
    add(
      const VendorOrdersFetchedEvent(VendorOrdersTab.processing, reset: true),
    );
  }

  void retryArchivedOrders() {
    add(const VendorOrdersFetchedEvent(VendorOrdersTab.archived, reset: true));
  }

  void openOrderDetail(VendorOrderEntity order, VendorOrdersTab tab) {
    final orderId = order.id?.trim();
    if (orderId == null || orderId.isEmpty) return;
    add(VendorOrderDetailFetchedEvent(orderId: orderId, tab: tab));
  }

  void refreshOrders(VendorOrdersTab tab) {
    add(VendorOrdersFetchedEvent(tab, reset: true));
  }

  void loadMoreOrders(VendorOrdersTab tab) {
    add(VendorOrdersFetchedEvent(tab, loadMore: true));
  }

  void retryOrderDetail() {
    final orderId = state.selectedOrderId?.trim();
    if (orderId == null || orderId.isEmpty) return;
    final tab = state.selectedOrderTab;
    if (tab == null) return;
    add(VendorOrderDetailFetchedEvent(orderId: orderId, tab: tab));
  }

  @override
  Future<void> close() {
    for (final timer in _searchDebounceTimers.values) {
      timer?.cancel();
    }
    return super.close();
  }
}

class _VendorOrdersOwner {
  const _VendorOrdersOwner({required this.shopId, required this.vendorId});

  final String shopId;
  final String vendorId;
}
