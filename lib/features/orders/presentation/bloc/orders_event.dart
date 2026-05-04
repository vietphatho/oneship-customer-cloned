import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class OrdersFetchingByStatusEvent extends OrdersEvent {
  final OrderStatus status;

  const OrdersFetchingByStatusEvent(this.status);
}

class OrdersLoadMoreByStatusEvent extends OrdersEvent {
  final OrderStatus status;

  OrdersLoadMoreByStatusEvent(this.status);
}

class OrderFetchDetailEvent extends OrdersEvent {
  final String shopId;
  final String orderId;

  OrderFetchDetailEvent({required this.shopId, required this.orderId});
}

class OrderDeleteEvent extends OrdersEvent {
  final OrderInfo order;

  OrderDeleteEvent(this.order);
}
