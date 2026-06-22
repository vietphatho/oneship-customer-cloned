import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor_home/data/constants/vendor_home_request_defaults.dart';
import 'package:oneship_customer/features/vendor_home/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor_home/domain/use_cases/fetch_vendor_archived_orders_use_case.dart';
import 'package:oneship_customer/features/vendor_home/domain/use_cases/fetch_vendor_processing_orders_use_case.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_event.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_order_tab.dart';
import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_state.dart';

@lazySingleton
class VendorHomeBloc extends Bloc<VendorHomeEvent, VendorHomeState> {
  VendorHomeBloc(
    this._fetchProcessingOrdersUseCase,
    this._fetchArchivedOrdersUseCase,
  ) : super(VendorHomeState.initial()) {
    on<VendorHomeInitEvent>(_onInit);
    on<VendorHomeOrdersFetchedEvent>(_onFetchOrders);
    on<VendorHomeOrderKeywordChangedEvent>(_onKeywordChanged);
  }

  static const _searchDebounce = Duration(milliseconds: 500);

  final FetchVendorProcessingOrdersUseCase _fetchProcessingOrdersUseCase;
  final FetchVendorArchivedOrdersUseCase _fetchArchivedOrdersUseCase;
  final Map<VendorHomeOrderTab, Timer?> _searchDebounceTimers = {};

  FutureOr<void> _onInit(
    VendorHomeInitEvent event,
    Emitter<VendorHomeState> emit,
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

    final responses = await Future.wait([
      _fetchProcessingOrdersUseCase(
        shopId: VendorHomeRequestDefaults.shopId,
        vendorId: VendorHomeRequestDefaults.vendorId,
        page: VendorHomeRequestDefaults.page,
        limit: VendorHomeRequestDefaults.limit,
        trackingCode: _trackingCodeOrNull(state.processingKeyword),
      ),
      _fetchArchivedOrdersUseCase(
        shopId: VendorHomeRequestDefaults.shopId,
        vendorId: VendorHomeRequestDefaults.vendorId,
        page: VendorHomeRequestDefaults.page,
        limit: VendorHomeRequestDefaults.limit,
        trackingCode: _trackingCodeOrNull(state.archivedKeyword),
      ),
    ]);

    final processingResponse = responses[0];
    final archivedResponse = responses[1];

    emit(
      state.copyWith(
        processingPage: VendorHomeRequestDefaults.page,
        archivedPage: VendorHomeRequestDefaults.page,
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
    VendorHomeOrdersFetchedEvent event,
    Emitter<VendorHomeState> emit,
  ) async {
    switch (event.tab) {
      case VendorHomeOrderTab.processing:
        await _fetchProcessingOrders(emit);
        break;
      case VendorHomeOrderTab.archived:
        await _fetchArchivedOrders(emit);
        break;
    }
  }

  FutureOr<void> _onKeywordChanged(
    VendorHomeOrderKeywordChangedEvent event,
    Emitter<VendorHomeState> emit,
  ) {
    final keyword = event.keyword.trim();

    switch (event.tab) {
      case VendorHomeOrderTab.processing:
        emit(state.copyWith(processingKeyword: keyword, processingPage: 1));
        break;
      case VendorHomeOrderTab.archived:
        emit(state.copyWith(archivedKeyword: keyword, archivedPage: 1));
        break;
    }

    _searchDebounceTimers[event.tab]?.cancel();
    _searchDebounceTimers[event.tab] = Timer(_searchDebounce, () {
      add(VendorHomeOrdersFetchedEvent(event.tab));
    });
  }

  Future<void> _fetchProcessingOrders(Emitter<VendorHomeState> emit) async {
    emit(
      state.copyWith(
        processingOrdersResource: Resource.loading(
          data: state.processingOrdersResource.data,
        ),
      ),
    );

    final response = await _fetchProcessingOrdersUseCase(
      shopId: VendorHomeRequestDefaults.shopId,
      vendorId: VendorHomeRequestDefaults.vendorId,
      page: state.processingPage,
      limit: VendorHomeRequestDefaults.limit,
      trackingCode: _trackingCodeOrNull(state.processingKeyword),
    );

    emit(
      state.copyWith(
        processingOrdersResource: response,
        processingOrders: _ordersOrCurrent(response, state.processingOrders),
      ),
    );
  }

  Future<void> _fetchArchivedOrders(Emitter<VendorHomeState> emit) async {
    emit(
      state.copyWith(
        archivedOrdersResource: Resource.loading(
          data: state.archivedOrdersResource.data,
        ),
      ),
    );

    final response = await _fetchArchivedOrdersUseCase(
      shopId: VendorHomeRequestDefaults.shopId,
      vendorId: VendorHomeRequestDefaults.vendorId,
      page: state.archivedPage,
      limit: VendorHomeRequestDefaults.limit,
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

  void init() {
    add(const VendorHomeInitEvent());
  }

  void searchProcessingOrders(String keyword) {
    add(
      VendorHomeOrderKeywordChangedEvent(
        tab: VendorHomeOrderTab.processing,
        keyword: keyword,
      ),
    );
  }

  void searchArchivedOrders(String keyword) {
    add(
      VendorHomeOrderKeywordChangedEvent(
        tab: VendorHomeOrderTab.archived,
        keyword: keyword,
      ),
    );
  }

  void retryProcessingOrders() {
    add(const VendorHomeOrdersFetchedEvent(VendorHomeOrderTab.processing));
  }

  void retryArchivedOrders() {
    add(const VendorHomeOrdersFetchedEvent(VendorHomeOrderTab.archived));
  }

  @override
  Future<void> close() {
    for (final timer in _searchDebounceTimers.values) {
      timer?.cancel();
    }
    return super.close();
  }
}
