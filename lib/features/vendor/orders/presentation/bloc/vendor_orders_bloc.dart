import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/orders/data/constants/vendor_orders_request_defaults.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/use_cases/fetch_vendor_archived_orders_use_case.dart';
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
    this._vendorProfileBloc,
  ) : super(VendorOrdersState.initial()) {
    on<VendorOrdersInitEvent>(_onInit);
    on<VendorOrdersFetchedEvent>(_onFetchOrders);
    on<VendorOrdersKeywordChangedEvent>(_onKeywordChanged);
  }

  static const _searchDebounce = Duration(milliseconds: 500);

  final FetchVendorProcessingOrdersUseCase _fetchProcessingOrdersUseCase;
  final FetchVendorArchivedOrdersUseCase _fetchArchivedOrdersUseCase;
  final VendorProfileBloc _vendorProfileBloc;
  final Map<VendorOrdersTab, Timer?> _searchDebounceTimers = {};

  FutureOr<void> _onInit(
    VendorOrdersInitEvent event,
    Emitter<VendorOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        processingOrdersResource: Resource.loading(
          data: state.processingOrdersResource.data,
        ),
        archivedOrdersResource: Resource.loading(
          data: state.archivedOrdersResource.data,
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
          archivedOrdersResource: Resource.error(
            'vendor_profile_not_loaded',
            0,
          ),
        ),
      );
      return;
    }

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
        processingOrders: _ordersOrCurrent(
          processingResponse,
          state.processingOrders,
        ),
        archivedOrders: _ordersOrCurrent(
          archivedResponse,
          state.archivedOrders,
        ),
      ),
    );
  }

  FutureOr<void> _onFetchOrders(
    VendorOrdersFetchedEvent event,
    Emitter<VendorOrdersState> emit,
  ) async {
    switch (event.tab) {
      case VendorOrdersTab.processing:
        await _fetchProcessingOrders(emit);
        break;
      case VendorOrdersTab.archived:
        await _fetchArchivedOrders(emit);
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
      add(VendorOrdersFetchedEvent(event.tab));
    });
  }

  Future<void> _fetchProcessingOrders(Emitter<VendorOrdersState> emit) async {
    emit(
      state.copyWith(
        processingOrdersResource: Resource.loading(
          data: state.processingOrdersResource.data,
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
      page: state.processingPage,
      limit: VendorOrdersRequestDefaults.limit,
      trackingCode: _trackingCodeOrNull(state.processingKeyword),
    );

    emit(
      state.copyWith(
        processingOrdersResource: response,
        processingOrders: _ordersOrCurrent(response, state.processingOrders),
      ),
    );
  }

  Future<void> _fetchArchivedOrders(Emitter<VendorOrdersState> emit) async {
    emit(
      state.copyWith(
        archivedOrdersResource: Resource.loading(
          data: state.archivedOrdersResource.data,
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
      page: state.archivedPage,
      limit: VendorOrdersRequestDefaults.limit,
      trackingCode: _trackingCodeOrNull(state.archivedKeyword),
    );

    emit(
      state.copyWith(
        archivedOrdersResource: response,
        archivedOrders: _ordersOrCurrent(response, state.archivedOrders),
      ),
    );
  }

  List<VendorOrderEntity> _ordersOrCurrent(
    Resource<VendorOrdersEntity> response,
    List<VendorOrderEntity> current,
  ) {
    if (response.state != Result.success) return current;
    return response.data?.items ?? [];
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
    add(const VendorOrdersFetchedEvent(VendorOrdersTab.processing));
  }

  void retryArchivedOrders() {
    add(const VendorOrdersFetchedEvent(VendorOrdersTab.archived));
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
