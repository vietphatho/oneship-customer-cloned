import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';

@lazySingleton
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this._repository)
    : super(OrdersFetchedByStatusState(Resource.loading())) {
    on<OrdersFetchingByStatusEvent>(_onFetchDataEvent);
  }

  final OrdersRepository _repository;

  late String _shopId;
  set shopId(String id) {
    _shopId = id;
  }

  BaseMetaResponse? _ordersMeta;

  List<OrderInfo> _pendingOrdersList = [];
  List<OrderInfo> get pendingOrdersList => _pendingOrdersList;

  List<OrderInfo> _processingOrdersList = [];
  List<OrderInfo> get processingOrdersList => _processingOrdersList;

  List<OrderInfo> _batchedOrdersList = [];
  List<OrderInfo> get batchedOrdersList => _batchedOrdersList;

  List<OrderInfo> _deliveringOrdersList = [];
  List<OrderInfo> get deliveringOrdersList => _deliveringOrdersList;

  List<OrderInfo> _delayedOrdersList = [];
  List<OrderInfo> get delayedOrdersList => _delayedOrdersList;

  List<OrderInfo> _canceledOrdersList = [];
  List<OrderInfo> get canceledOrdersList => _canceledOrdersList;

  List<OrderInfo> _returnedOrdersList = [];
  List<OrderInfo> get returnedOrdersList => _returnedOrdersList;

  OrderStatus _currentOrderStatus = OrderStatus.pending;
  OrderStatus get currentOrderStatus => _currentOrderStatus;
  set currentOrderStatus(OrderStatus status) => _currentOrderStatus = status;

  FutureOr<void> _onFetchDataEvent(
    OrdersFetchingByStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersFetchedByStatusState(Resource.loading()));
    // _currentOrderStatus = event.status;
    final response = await _repository.fetchOrdersByStatus(
      status: _currentOrderStatus,
      shopId: _shopId,
    );
    _ordersMeta = response.data?.meta;
    switch (_currentOrderStatus) {
      case OrderStatus.pending:
        _pendingOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.processing:
        _processingOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.batched:
        _batchedOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.shipping:
        _deliveringOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.delayed:
        _delayedOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.cancelled:
        _canceledOrdersList = response.data?.data ?? [];
        break;
      case OrderStatus.returned:
        _returnedOrdersList = response.data?.data ?? [];
        break;
      default:
    }
    emit(OrdersFetchedByStatusState(response));
  }

  void fetchOrdersByStatus() {
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }

  void init(String shopId) {
    _shopId = shopId;
    add(OrdersFetchingByStatusEvent(_currentOrderStatus));
  }
}
