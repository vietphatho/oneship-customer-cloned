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
  }

  final OrdersRepository _repository;
  final FetchOrderDetailUseCase _fetchOrderDetailUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;

  late String _shopId;
  set shopId(String id) {
    _shopId = id;
  }

  BaseMetaResponse? _ordersMeta;

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

    // Prepare new state lists
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

    // Refetch orders after deletion
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void fetchOrdersByStatus() {
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void fetchOrderDetail({required String shopId, required String orderId}) {
    add(OrderFetchDetailEvent(shopId: shopId, orderId: orderId));
  }

  void init(String shopId) {
    _shopId = shopId;
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void deleteOrder(OrderInfo order) {
    add(OrderDeleteEvent(order));
  }
}
