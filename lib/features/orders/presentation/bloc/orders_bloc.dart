import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
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
          orderDetailResource: Resource.loading(),
          deleteOrderResource: Resource.loading(),
        ),
      ) {
    on<OrdersFetchingByStatusEvent>(_onFetchDataEvent);
    on<OrderFetchDetailEvent>(_onFetchDetailEvent);
    on<OrderDeleteEvent>(_onDeleteOrderEvent);
    on<ArchivedOrdersFetchingByStatusEvent>(_onFetchArchivedOrdersEvent);
    on<OrdersHistoryFilterToggledEvent>(_onToggleOrdersHistoryFilterEvent);
    on<OrdersHistoryFilterAppliedEvent>(_onApplyOrdersHistoryFilterEvent);
    on<OrdersHistoryFilterClearedEvent>(_onClearOrdersHistoryFilterEvent);
  }

  final OrdersRepository _repository;
  final FetchOrderDetailUseCase _fetchOrderDetailUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;
  final OrdersHistoryController _ordersHistoryController =
      OrdersHistoryController();

  late String _shopId;
  set shopId(String id) {
    _shopId = id;
  }

  BaseMetaResponse? _ordersMeta;

  List<OrderInfo> get deliveredArchivedOrdersList =>
      _ordersHistoryController.deliveredOrders;

  List<OrderInfo> get returnedArchivedOrdersList =>
      _ordersHistoryController.returnedOrders;

  bool get showOrdersHistoryFilters => _ordersHistoryController.showFilters;

  OrdersHistoryFilters get ordersHistoryFilters =>
      _ordersHistoryController.filters;

  List<OrderInfo> get filteredDeliveredArchivedOrdersList =>
      _ordersHistoryController.filteredDeliveredOrders;

  List<OrderInfo> get filteredReturnedArchivedOrdersList =>
      _ordersHistoryController.filteredReturnedOrders;

  List<OrderInfo> get visibleDeliveredArchivedOrdersList =>
      _ordersHistoryController.visibleDeliveredOrders;

  List<OrderInfo> get visibleReturnedArchivedOrdersList =>
      _ordersHistoryController.visibleReturnedOrders;

  double get ordersHistoryMaxCodAmount =>
      _ordersHistoryController.maxCodAmount;

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

  FutureOr<void> _onFetchArchivedOrdersEvent(
    ArchivedOrdersFetchingByStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(orderListByStatusResource: Resource.loading()));
    final response = await _repository.fetchArchivedOrders(
      status: event.status,
      shopId: _shopId,
    );

    if (event.status == OrderStatus.delivered ||
        event.status == OrderStatus.returned) {
      _ordersHistoryController.setOrders(
        event.status,
        response.data?.data ?? [],
      );
    }

    emit(
      state.copyWith(
        orderListByStatusResource: response,
        ordersHistoryVersion: state.ordersHistoryVersion + 1,
      ),
    );
  }

  FutureOr<void> _onToggleOrdersHistoryFilterEvent(
    OrdersHistoryFilterToggledEvent event,
    Emitter<OrdersState> emit,
  ) {
    _ordersHistoryController.toggleFilters();
    emit(
      state.copyWith(ordersHistoryVersion: state.ordersHistoryVersion + 1),
    );
  }

  FutureOr<void> _onApplyOrdersHistoryFilterEvent(
    OrdersHistoryFilterAppliedEvent event,
    Emitter<OrdersState> emit,
  ) {
    _ordersHistoryController.applyFilters(event.filters);
    emit(
      state.copyWith(ordersHistoryVersion: state.ordersHistoryVersion + 1),
    );
  }

  FutureOr<void> _onClearOrdersHistoryFilterEvent(
    OrdersHistoryFilterClearedEvent event,
    Emitter<OrdersState> emit,
  ) {
    _ordersHistoryController.clearFilters();
    emit(
      state.copyWith(ordersHistoryVersion: state.ordersHistoryVersion + 1),
    );
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

  void fetchArchivedOrders(OrderStatus status) {
    add(ArchivedOrdersFetchingByStatusEvent(status));
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
