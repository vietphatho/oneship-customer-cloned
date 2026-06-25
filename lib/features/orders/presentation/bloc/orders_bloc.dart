import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_by_status_lists.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/delete_order_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_order_detail_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_order_history_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_orders_by_status_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/get_shipper_info_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_orders_by_status_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/validate_ord_at_hub_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_filter_panel.dart';

@lazySingleton
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(
    this._fetchOrdersByStatusUseCase,
    this._fetchOrderHistoryUseCase,
    this._fetchOrderDetailUseCase,
    this._deleteOrderUseCase,
    // this._resolveOrdersHistoryViewDataUseCase,
    this._resolveOrdersByStatusUseCase,
    this._getShipperInfoUseCase,
    this._validateOrdAtHubUseCase,
  ) : super(
        OrdersState(
          orderListByStatusResource: Resource.loading(),
          ordersHistoryResource: Resource.loading(),
          orderDetailResource: Resource.loading(),
          deleteOrderResource: Resource.loading(),
          validateOrdAtHubResource: Resource.loading(),
        ),
      ) {
    on<OrdersFetchingByStatusEvent>(_onFetchDataEvent);
    on<OrdersLoadMoreByStatusEvent>(_onLoadMoreOrdsEvent);
    on<OrderFetchDetailEvent>(_onFetchDetailEvent);
    on<OrderDetailUpdatedEvent>(_onUpdateDetailEvent);
    on<OrderHistoryOpenDetailEvent>(_onOpenHistoryDetailEvent);
    on<OrderDeleteEvent>(_onDeleteOrderEvent);
    on<OrdersHistoryFetchingByStatusEvent>(_onFetchOrderHistoryEvent);
    on<OrdersHistoryLoadMoreEvent>(_onLoadMoreOrderHistoryEvent);
    on<ValidateOrdAtHubEvent>(_onValidateOrdAtHubEvent);
    // on<OrdersHistoryFilterToggledEvent>(_onToggleOrdersHistoryFilterEvent);
    // on<OrdersHistoryFilterAppliedEvent>(_onApplyOrdersHistoryFilterEvent);
    // on<OrdersHistoryFilterClearedEvent>(_onClearOrdersHistoryFilterEvent);
    on<ProcessingOrdersFilterAppliedEvent>(_onApplyProcessingOrdersFilterEvent);
  }

  final FetchOrdersByStatusUseCase _fetchOrdersByStatusUseCase;
  final FetchOrderHistoryUseCase _fetchOrderHistoryUseCase;
  final FetchOrderDetailUseCase _fetchOrderDetailUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;
  // final ResolveOrdersHistoryViewDataUseCase
  // _resolveOrdersHistoryViewDataUseCase;
  final ResolveOrdersByStatusUseCase _resolveOrdersByStatusUseCase;
  final GetShipperInfoUseCase _getShipperInfoUseCase;
  final ValidateOrdAtHubUseCase _validateOrdAtHubUseCase;

  late String _shopId;
  set shopId(String id) {
    _shopId = id;
  }

  BaseMetaResponse? _ordersMeta;
  BaseMetaResponse? _deliveredOrdersHistoryMeta;
  BaseMetaResponse? _returnedOrdersHistoryMeta;
  BaseMetaResponse? _allOrdersHistoryMeta;

  OrderStatus _currentOrderStatus = OrderStatus.pending;
  set currentOrderStatus(OrderStatus status) => _currentOrderStatus = status;

  FutureOr<void> _onFetchDataEvent(
    OrdersFetchingByStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(orderListByStatusResource: Resource.loading()));
    final response = await _fetchOrdersByStatusUseCase.call(
      status: _currentOrderStatus,
      shopId: _shopId,
    );
    _ordersMeta = response.data?.meta;

    final ordersByStatus = _resolveOrdersByStatusUseCase.call(
      status: _currentOrderStatus,
      orders: response.data?.data ?? [],
      current: OrdersByStatusLists(
        allProcessingOrdersList: state.allProcessingOrdersList,
        atHubOrdersList: state.atHubOrdersList,
        pendingOrdersList: state.pendingOrdersList,
        processingOrdersList: state.processingOrdersList,
        batchedOrdersList: state.batchedOrdersList,
        deliveringOrdersList: state.deliveringOrdersList,
        delayedOrdersList: state.delayedOrdersList,
        cancelledOrdersList: state.cancelledOrdersList,
        returnedOrdersList: state.returnedOrdersList,
      ),
    );

    emit(
      state.copyWith(
        orderListByStatusResource: response,
        allProcessingOrdersList: ordersByStatus.allProcessingOrdersList,
        atHubOrdersList: ordersByStatus.atHubOrdersList,
        pendingOrdersList: ordersByStatus.pendingOrdersList,
        processingOrdersList: ordersByStatus.processingOrdersList,
        batchedOrdersList: ordersByStatus.batchedOrdersList,
        deliveringOrdersList: ordersByStatus.deliveringOrdersList,
        delayedOrdersList: ordersByStatus.delayedOrdersList,
        cancelledOrdersList: ordersByStatus.cancelledOrdersList,
        returnedOrdersList: ordersByStatus.returnedOrdersList,
      ),
    );
  }

  FutureOr<void> _onFetchDetailEvent(
    OrderFetchDetailEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(orderDetailResource: Resource.loading()));
    final response = await _fetchOrderDetailUseCase.call(
      shopId: event.shopId,
      orderId: event.orderId,
    );

    if (response.data?.shipperCodes.firstOrNull != null) {
      final shipperResponse = await _getShipperInfoUseCase.call(
        response.data!.shipperCodes.first,
      );

      var data = response.data?.copyWith(shipper: shipperResponse.data);
      var ordDtl = response.copyWith(data: data);
      emit(state.copyWith(orderDetailResource: ordDtl));
      return;
    }

    emit(state.copyWith(orderDetailResource: response));
  }

  FutureOr<void> _onUpdateDetailEvent(
    OrderDetailUpdatedEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(orderDetailResource: Resource.success(event.order)));
  }

  FutureOr<void> _onDeleteOrderEvent(
    OrderDeleteEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(deleteOrderResource: Resource.loading()));
    final response = await _deleteOrderUseCase.call(event.order);
    emit(state.copyWith(deleteOrderResource: response));
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  FutureOr<void> _onFetchOrderHistoryEvent(
    OrdersHistoryFetchingByStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(ordersHistoryResource: Resource.loading()));
    final response = await _fetchOrderHistoryUseCase.call(
      status: event.status,
      shopId: _shopId,
    );
    _setOrdersHistoryMeta(event.status, response.data?.meta);

    // final orders = response.data?.orders ?? [];
    // final nextState = state.copyWith(
    //   ordersHistoryResource: response,
    //   deliveredOrdersHistoryList:
    //       event.status == OrderStatus.delivered
    //           ? orders
    //           : state.deliveredOrdersHistoryList,
    //   returnedOrdersHistoryList:
    //       event.status == OrderStatus.returned
    //           ? orders
    //           : state.returnedOrdersHistoryList,
    // );
    // emit(_resolveOrdersHistoryViewData(nextState));

    switch (event.status) {
      case OrderStatus.delivered:
        emit(
          state.copyWith(
            deliveredOrdersHistoryList: response.data?.items ?? [],
          ),
        );
        break;
      case OrderStatus.returned:
        emit(
          state.copyWith(returnedOrdersHistoryList: response.data?.items ?? []),
        );
        break;
      case OrderStatus.allProcessing:
        emit(state.copyWith(allOrdersHistoryList: response.data?.items ?? []));
        break;
      default:
    }
    emit(state.copyWith(ordersHistoryResource: response));
  }

  FutureOr<void> _onLoadMoreOrderHistoryEvent(
    OrdersHistoryLoadMoreEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (!hasMoreOrderHistory(event.status)) return null;
    final meta = _getOrdersHistoryMeta(event.status);

    final response = await _fetchOrderHistoryUseCase.call(
      status: event.status,
      shopId: _shopId,
      page: (meta?.page ?? 0) + 1,
    );
    _setOrdersHistoryMeta(event.status, response.data?.meta);

    final orders = response.data?.items ?? [];
    emit(
      state.copyWith(
        ordersHistoryResource: response,
        deliveredOrdersHistoryList: event.status == OrderStatus.delivered
            ? [...state.deliveredOrdersHistoryList, ...orders]
            : state.deliveredOrdersHistoryList,
        returnedOrdersHistoryList: event.status == OrderStatus.returned
            ? [...state.returnedOrdersHistoryList, ...orders]
            : state.returnedOrdersHistoryList,
        allOrdersHistoryList: event.status == OrderStatus.allProcessing
            ? [...state.allOrdersHistoryList, ...orders]
            : state.allOrdersHistoryList,
      ),
    );
  }

  // FutureOr<void> _onToggleOrdersHistoryFilterEvent(
  //   OrdersHistoryFilterToggledEvent event,
  //   Emitter<OrdersState> emit,
  // ) {
  //   emit(
  //     state.copyWith(showOrdersHistoryFilters: !state.showOrdersHistoryFilters),
  //   );
  // }

  // FutureOr<void> _onApplyOrdersHistoryFilterEvent(
  //   OrdersHistoryFilterAppliedEvent event,
  //   Emitter<OrdersState> emit,
  // ) {
  //   final nextState = state.copyWith(
  //     ordersHistoryFilters: event.filters,
  //     showOrdersHistoryFilters: false,
  //   );
  //   emit(_resolveOrdersHistoryViewData(nextState));
  // }

  // FutureOr<void> _onClearOrdersHistoryFilterEvent(
  //   OrdersHistoryFilterClearedEvent event,
  //   Emitter<OrdersState> emit,
  // ) {
  //   final nextState = state.copyWith(
  //     ordersHistoryFilters: OrdersHistoryFilters.empty(),
  //     showOrdersHistoryFilters: false,
  //   );
  //   emit(_resolveOrdersHistoryViewData(nextState));
  // }

  FutureOr<void> _onLoadMoreOrdsEvent(
    OrdersLoadMoreByStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    bool hasMore = false;
    if (_ordersMeta != null) {
      if (_ordersMeta!.hasNext != null) {
        hasMore = _ordersMeta!.hasNext!;
      } else {
        final total = _ordersMeta!.total ?? 0;
        final page = _ordersMeta!.page ?? 1;
        final limit = _ordersMeta!.limit ?? Constants.defaultLimitPerPage;
        hasMore = (page * limit) < total;
      }
    }

    if (!hasMore) return null;

    final response = await _fetchOrdersByStatusUseCase.call(
      status: _currentOrderStatus,
      shopId: _shopId,
      page: (_ordersMeta?.page ?? 0) + 1,
    );
    _ordersMeta = response.data?.meta;

    final ordersByStatus = _resolveOrdersByStatusUseCase.append(
      status: _currentOrderStatus,
      orders: response.data?.data ?? [],
      current: OrdersByStatusLists(
        allProcessingOrdersList: state.allProcessingOrdersList,
        atHubOrdersList: state.atHubOrdersList,
        pendingOrdersList: state.pendingOrdersList,
        processingOrdersList: state.processingOrdersList,
        batchedOrdersList: state.batchedOrdersList,
        deliveringOrdersList: state.deliveringOrdersList,
        delayedOrdersList: state.delayedOrdersList,
        cancelledOrdersList: state.cancelledOrdersList,
        returnedOrdersList: state.returnedOrdersList,
      ),
    );

    emit(
      state.copyWith(
        orderListByStatusResource: response,
        allProcessingOrdersList: ordersByStatus.allProcessingOrdersList,
        atHubOrdersList: ordersByStatus.atHubOrdersList,
        pendingOrdersList: ordersByStatus.pendingOrdersList,
        processingOrdersList: ordersByStatus.processingOrdersList,
        batchedOrdersList: ordersByStatus.batchedOrdersList,
        deliveringOrdersList: ordersByStatus.deliveringOrdersList,
        delayedOrdersList: ordersByStatus.delayedOrdersList,
        cancelledOrdersList: ordersByStatus.cancelledOrdersList,
        returnedOrdersList: ordersByStatus.returnedOrdersList,
      ),
    );
  }

  // OrdersState _resolveOrdersHistoryViewData(OrdersState source) {
  //   final viewData = _resolveOrdersHistoryViewDataUseCase.call(
  //     deliveredOrders: source.deliveredOrdersHistoryList,
  //     returnedOrders: source.returnedOrdersHistoryList,
  //     provinceCode: source.ordersHistoryFilters.province?.code,
  //     wardCode: source.ordersHistoryFilters.ward?.code,
  //     createdDate: source.ordersHistoryFilters.createdDate,
  //     phone: source.ordersHistoryFilters.phone,
  //     orderCode: source.ordersHistoryFilters.orderCode,
  //     minCodAmount: source.ordersHistoryFilters.codRange.start,
  //     maxCodFilterAmount: source.ordersHistoryFilters.codRange.end,
  //   );

  //   return source.copyWith(
  //     filteredDeliveredOrdersHistoryList: viewData.filteredDeliveredOrders,
  //     filteredReturnedOrdersHistoryList: viewData.filteredReturnedOrders,
  //     visibleDeliveredOrdersHistoryList: viewData.visibleDeliveredOrders,
  //     visibleReturnedOrdersHistoryList: viewData.visibleReturnedOrders,
  //     ordersHistoryMaxCodAmount: viewData.maxCodAmount,
  //   );
  // }

  FutureOr<void> _onValidateOrdAtHubEvent(
    ValidateOrdAtHubEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(validateOrdAtHubResource: Resource.loading()));
    final response = await _validateOrdAtHubUseCase.call(
      hubId: event.hubId,
      ordId: event.ordId,
    );

    if (response.state == Result.success) {
      add(OrdersFetchingByStatusEvent(_currentOrderStatus));
    }

    emit(state.copyWith(validateOrdAtHubResource: response));
  }

  BaseMetaResponse? _getOrdersHistoryMeta(OrderStatus status) {
    if (status == OrderStatus.delivered) return _deliveredOrdersHistoryMeta;
    if (status == OrderStatus.returned) return _returnedOrdersHistoryMeta;
    if (status == OrderStatus.allProcessing) return _allOrdersHistoryMeta;
    return null;
  }

  void _setOrdersHistoryMeta(OrderStatus status, BaseMetaResponse? meta) {
    if (status == OrderStatus.delivered) {
      _deliveredOrdersHistoryMeta = meta;
      return;
    }
    if (status == OrderStatus.returned) {
      _returnedOrdersHistoryMeta = meta;
      return;
    }
    if (status == OrderStatus.allProcessing) {
      _allOrdersHistoryMeta = meta;
    }
  }

  void fetchOrdersByStatus() {
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void loadMoreOrders() {
    add(OrdersLoadMoreByStatusEvent(_currentOrderStatus));
  }

  void fetchOrderDetail({required String shopId, required String orderId}) {
    add(OrderFetchDetailEvent(shopId: shopId, orderId: orderId));
  }

  void openOrderDetail(OrderInfo order) {
    final shopId = order.shopId;
    final orderId = order.id;
    if ((shopId?.isNotEmpty ?? false) && (orderId?.isNotEmpty ?? false)) {
      add(OrderFetchDetailEvent(shopId: shopId!, orderId: orderId!));
    }
  }

  void setOrderDetail(OrderDetailEntity order) {
    add(OrderDetailUpdatedEvent(order));
  }

  FutureOr<void> _onOpenHistoryDetailEvent(
    OrderHistoryOpenDetailEvent event,
    Emitter<OrdersState> emit,
  ) async {
    OrderDetailEntity ordDtl = OrderDetailEntity.fromHistoryModel(event.order);
    emit(state.copyWith(orderDetailResource: Resource.loading()));

    if (ordDtl.shipperCodes.firstOrNull != null) {
      final shipperResponse = await _getShipperInfoUseCase.call(
        ordDtl.shipperCodes.first,
      );

      ordDtl = ordDtl.copyWith(shipper: shipperResponse.data);
    }

    emit(state.copyWith(orderDetailResource: Resource.success(ordDtl)));
  }

  void openOrderHistoryDetail(OrdersHistoryEntity order) {
    add(OrderHistoryOpenDetailEvent(order));
  }

  void validateOrdAtHub({required String ordId, required String hubId}) {
    add(ValidateOrdAtHubEvent(hubId: hubId, ordId: ordId));
  }

  void deleteOrder(OrderInfo order) {
    add(OrderDeleteEvent(order));
  }

  void fetchOrderHistory(OrderStatus status) {
    add(OrdersHistoryFetchingByStatusEvent(status));
  }

  void loadMoreOrderHistory(OrderStatus status) {
    add(OrdersHistoryLoadMoreEvent(status));
  }

  bool hasMoreOrderHistory(OrderStatus status) {
    final meta = _getOrdersHistoryMeta(status);
    if (meta == null) return false;
    if (meta.hasNext != null) return meta.hasNext!;
    final total = meta.total ?? 0;
    final page = meta.page ?? 1;
    final limit = meta.limit ?? Constants.defaultLimitPerPage;
    return (page * limit) < total;
  }

  void toggleOrdersHistoryFilters() {
    add(const OrdersHistoryFilterToggledEvent());
  }

  void applyOrdersHistoryFilters(OrdersHistoryFilters filters) {
    add(OrdersHistoryFilterAppliedEvent(filters));
  }

  void clearOrdersHistoryFilters() {
    add(const OrdersHistoryFilterClearedEvent());
  }

  void applyProcessingOrdersFilters(ProcessingOrdersFilters filters) {
    add(ProcessingOrdersFilterAppliedEvent(filters));
  }

  FutureOr<void> _onApplyProcessingOrdersFilterEvent(
    ProcessingOrdersFilterAppliedEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(processingOrdersFilters: event.filters));
  }

  void init(String shopId) {
    _shopId = shopId;
    // add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }
}
