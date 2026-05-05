import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

class OrdersByStatusLists {
  const OrdersByStatusLists({
    required this.pendingOrdersList,
    required this.processingOrdersList,
    required this.batchedOrdersList,
    required this.deliveringOrdersList,
    required this.delayedOrdersList,
    required this.cancelledOrdersList,
    required this.returnedOrdersList,
  });

  final List<OrderInfo> pendingOrdersList;
  final List<OrderInfo> processingOrdersList;
  final List<OrderInfo> batchedOrdersList;
  final List<OrderInfo> deliveringOrdersList;
  final List<OrderInfo> delayedOrdersList;
  final List<OrderInfo> cancelledOrdersList;
  final List<OrderInfo> returnedOrdersList;

  OrdersByStatusLists copyWith({
    List<OrderInfo>? pendingOrdersList,
    List<OrderInfo>? processingOrdersList,
    List<OrderInfo>? batchedOrdersList,
    List<OrderInfo>? deliveringOrdersList,
    List<OrderInfo>? delayedOrdersList,
    List<OrderInfo>? cancelledOrdersList,
    List<OrderInfo>? returnedOrdersList,
  }) {
    return OrdersByStatusLists(
      pendingOrdersList: pendingOrdersList ?? this.pendingOrdersList,
      processingOrdersList: processingOrdersList ?? this.processingOrdersList,
      batchedOrdersList: batchedOrdersList ?? this.batchedOrdersList,
      deliveringOrdersList: deliveringOrdersList ?? this.deliveringOrdersList,
      delayedOrdersList: delayedOrdersList ?? this.delayedOrdersList,
      cancelledOrdersList: cancelledOrdersList ?? this.cancelledOrdersList,
      returnedOrdersList: returnedOrdersList ?? this.returnedOrdersList,
    );
  }
}
