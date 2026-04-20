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
