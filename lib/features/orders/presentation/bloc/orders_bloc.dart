import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/delete_order_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/fetch_order_detail_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_controller.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';

@lazySingleton
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(
    this._repository,
    this._fetchOrderDetailUseCase,
    this._deleteOrderUseCase,
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

  final OrdersRepository _repository;
  final FetchOrderDetailUseCase _fetchOrderDetailUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;
  static const int _ordersHistoryPageSize = 10;

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
      _applyOrdersHistoryFilters(state.deliveredOrdersHistoryList);

  List<OrderHistoryInfoEntity> get filteredReturnedArchivedOrdersList =>
      _applyOrdersHistoryFilters(state.returnedOrdersHistoryList);

  List<OrderHistoryInfoEntity> get visibleDeliveredArchivedOrdersList =>
      _limitOrdersHistory(filteredDeliveredArchivedOrdersList);

  List<OrderHistoryInfoEntity> get visibleReturnedArchivedOrdersList =>
      _limitOrdersHistory(filteredReturnedArchivedOrdersList);

  double get ordersHistoryMaxCodAmount {
    final allOrders = [
      ...state.deliveredOrdersHistoryList,
      ...state.returnedOrdersHistoryList,
    ];
    if (allOrders.isEmpty) return 1000000;

    final maxCod = allOrders
        .map((order) => (order.codAmount ?? 0).toDouble())
        .reduce((current, next) => current > next ? current : next);

    if (maxCod <= 0) return 1000000;
    if (maxCod < 1000000) return 1000000;
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
    final response = await _repository.fetchOrdersByStatus(
      status: _currentOrderStatus,
      shopId: _shopId,
    );
    _ordersMeta = response.data?.meta;

    List<OrderInfo> pendingOrdersList = state.pendingOrdersList;
    List<OrderInfo> processingOrdersList = state.processingOrdersList;
    List<OrderInfo> batchedOrdersList = state.batchedOrdersList;
    List<OrderInfo> deliveringOrdersList = state.deliveringOrdersList;
    List<OrderInfo> delayedOrdersList = state.delayedOrdersList;
    List<OrderInfo> cancelledOrdersList = state.cancelledOrdersList;
    List<OrderInfo> returnedOrdersList = state.returnedOrdersList;

    switch (_currentOrderStatus) {
      case OrderStatus.pending:
        pendingOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.processing:
        processingOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.batched:
        batchedOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.shipping:
        deliveringOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.delayed:
        delayedOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.cancelled:
        cancelledOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.returned:
        returnedOrdersList = response.data?.data ?? [];
        break;
      default:
        break;
    }

    emit(
      state.copyWith(
        orderListByStatusResource: response,
        pendingOrdersList: pendingOrdersList,
        processingOrdersList: processingOrdersList,
        batchedOrdersList: batchedOrdersList,
        deliveringOrdersList: deliveringOrdersList,
        delayedOrdersList: delayedOrdersList,
        cancelledOrdersList: cancelledOrdersList,
        returnedOrdersList: returnedOrdersList,
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
    final response = await _repository.fetchOrderHistory(
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

  List<OrderHistoryInfoEntity> _applyOrdersHistoryFilters(
    List<OrderHistoryInfoEntity> orders,
  ) {
    final filters = state.ordersHistoryFilters;

    return orders.where((order) {
      final provinceCode = order.city ?? order.provinceCode;
      if (filters.province != null && provinceCode != filters.province!.code) {
        return false;
      }

      final wardCode = order.ward ?? order.wardCode;
      if (filters.ward != null && wardCode != filters.ward!.code) {
        return false;
      }

      if (filters.phone.isNotEmpty &&
          !(order.phone ?? "").toLowerCase().contains(
            filters.phone.toLowerCase(),
          )) {
        return false;
      }

      if (filters.orderCode.isNotEmpty &&
          !(order.orderNumber ?? "").toLowerCase().contains(
            filters.orderCode.toLowerCase(),
          )) {
        return false;
      }

      if (filters.createdDate != null &&
          !_isSameDate(order.createdAt, filters.createdDate)) {
        return false;
      }

      final codAmount = (order.codAmount ?? 0).toDouble();
      if (codAmount < filters.codRange.start ||
          codAmount > filters.codRange.end) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _isSameDate(DateTime? source, DateTime? target) {
    if (source == null || target == null) return false;

    final local = source.toLocal();
    return local.year == target.year &&
        local.month == target.month &&
        local.day == target.day;
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
