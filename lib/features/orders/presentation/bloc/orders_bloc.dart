import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/apply_orders_history_filters_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/delete_order_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_order_history_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_order_detail_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_orders_by_status_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_orders_by_status_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';

@lazySingleton
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(
    this._fetchOrdersByStatusUseCase,
    this._fetchOrderHistoryUseCase,
    this._fetchOrderDetailUseCase,
    this._deleteOrderUseCase,
    this._applyOrdersHistoryFiltersUseCase,
    this._resolveOrdersByStatusUseCase,
  ) : super(
        OrdersState(
          orderListByStatusResource: Resource.loading(),
          ordersHistoryResource: Resource.loading(),
          orderDetailResource: Resource.loading(),
          deleteOrderResource: Resource.loading(),
        ),
      ) {
    on<OrdersFetchingByStatusEvent>(_onFetchDataEvent);
    on<OrderFetchDetailEvent>(_onFetchDetailEvent);
    on<OrderDeleteEvent>(_onDeleteOrderEvent);
    on<OrdersHistoryFetchingByStatusEvent>(_onFetchOrderHistoryEvent);
    on<OrdersHistoryFilterToggledEvent>(_onToggleOrdersHistoryFilterEvent);
    on<OrdersHistoryFilterAppliedEvent>(_onApplyOrdersHistoryFilterEvent);
    on<OrdersHistoryFilterClearedEvent>(_onClearOrdersHistoryFilterEvent);
  }

  final FetchOrdersByStatusUseCase _fetchOrdersByStatusUseCase;
  final FetchOrderHistoryUseCase _fetchOrderHistoryUseCase;
  final FetchOrderDetailUseCase _fetchOrderDetailUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;
  final ApplyOrdersHistoryFiltersUseCase _applyOrdersHistoryFiltersUseCase;
  final ResolveOrdersByStatusUseCase _resolveOrdersByStatusUseCase;
  static const int _ordersHistoryPageSize = 10;
  static const double _defaultMaxCodAmount = 1000000;

  late String _shopId;
  set shopId(String id) {
    _shopId = id;
  }

  BaseMetaResponse? _ordersMeta;

  List<OrderHistoryInfoEntity> get deliveredArchivedOrdersList =>
      state.deliveredOrdersHistoryList;

  List<OrderHistoryInfoEntity> get returnedArchivedOrdersList =>
      state.returnedOrdersHistoryList;

  bool get showOrdersHistoryFilters => state.showOrdersHistoryFilters;

  OrdersHistoryFilters get ordersHistoryFilters => state.ordersHistoryFilters;

  List<OrderHistoryInfoEntity> get filteredDeliveredArchivedOrdersList =>
      _applyOrdersHistoryFiltersUseCase.call(
        orders: state.deliveredOrdersHistoryList,
        provinceCode: state.ordersHistoryFilters.province?.code,
        wardCode: state.ordersHistoryFilters.ward?.code,
        createdDate: state.ordersHistoryFilters.createdDate,
        phone: state.ordersHistoryFilters.phone,
        orderCode: state.ordersHistoryFilters.orderCode,
        minCodAmount: state.ordersHistoryFilters.codRange.start,
        maxCodAmount: state.ordersHistoryFilters.codRange.end,
      );

  List<OrderHistoryInfoEntity> get filteredReturnedArchivedOrdersList =>
      _applyOrdersHistoryFiltersUseCase.call(
        orders: state.returnedOrdersHistoryList,
        provinceCode: state.ordersHistoryFilters.province?.code,
        wardCode: state.ordersHistoryFilters.ward?.code,
        createdDate: state.ordersHistoryFilters.createdDate,
        phone: state.ordersHistoryFilters.phone,
        orderCode: state.ordersHistoryFilters.orderCode,
        minCodAmount: state.ordersHistoryFilters.codRange.start,
        maxCodAmount: state.ordersHistoryFilters.codRange.end,
      );

  List<OrderHistoryInfoEntity> get visibleDeliveredArchivedOrdersList =>
      _limitOrdersHistory(filteredDeliveredArchivedOrdersList);

  List<OrderHistoryInfoEntity> get visibleReturnedArchivedOrdersList =>
      _limitOrdersHistory(filteredReturnedArchivedOrdersList);

  double get ordersHistoryMaxCodAmount {
    final allOrders = [
      ...state.deliveredOrdersHistoryList,
      ...state.returnedOrdersHistoryList,
    ];
    if (allOrders.isEmpty) return _defaultMaxCodAmount;

    final maxCod = allOrders
        .map((order) => (order.codAmount ?? 0).toDouble())
        .reduce((current, next) => current > next ? current : next);

    if (maxCod <= 0) return _defaultMaxCodAmount;
    if (maxCod < _defaultMaxCodAmount) return _defaultMaxCodAmount;
    return maxCod;
  }

  OrderStatus _currentOrderStatus = OrderStatus.pending;
  OrderStatus get currentOrderStatus => _currentOrderStatus;
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
    emit(state.copyWith(orderDetailResource: response));
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

    final orders = response.data?.orders ?? [];
    emit(
      state.copyWith(
        ordersHistoryResource: response,
        deliveredOrdersHistoryList:
            event.status == OrderStatus.delivered
                ? orders
                : state.deliveredOrdersHistoryList,
        returnedOrdersHistoryList:
            event.status == OrderStatus.returned
                ? orders
                : state.returnedOrdersHistoryList,
      ),
    );
  }

  FutureOr<void> _onToggleOrdersHistoryFilterEvent(
    OrdersHistoryFilterToggledEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(showOrdersHistoryFilters: !state.showOrdersHistoryFilters),
    );
  }

  FutureOr<void> _onApplyOrdersHistoryFilterEvent(
    OrdersHistoryFilterAppliedEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(
        ordersHistoryFilters: event.filters,
        showOrdersHistoryFilters: false,
      ),
    );
  }

  FutureOr<void> _onClearOrdersHistoryFilterEvent(
    OrdersHistoryFilterClearedEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(
        ordersHistoryFilters: OrdersHistoryFilters.empty(),
        showOrdersHistoryFilters: false,
      ),
    );
  }

  List<OrderHistoryInfoEntity> _limitOrdersHistory(
    List<OrderHistoryInfoEntity> orders,
  ) {
    if (orders.length <= _ordersHistoryPageSize) return orders;
    return orders.take(_ordersHistoryPageSize).toList();
  }

  void fetchOrdersByStatus() {
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void fetchOrderDetail({required String shopId, required String orderId}) {
    add(OrderFetchDetailEvent(shopId: shopId, orderId: orderId));
  }

  void deleteOrder(OrderInfo order) {
    add(OrderDeleteEvent(order));
  }

  void fetchOrderHistory(OrderStatus status) {
    add(OrdersHistoryFetchingByStatusEvent(status));
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

  void init(String shopId) {
    _shopId = shopId;
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }
}
