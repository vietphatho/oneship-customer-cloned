import 'package:oneship_customer/features/orders/data/enum.dart';

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
