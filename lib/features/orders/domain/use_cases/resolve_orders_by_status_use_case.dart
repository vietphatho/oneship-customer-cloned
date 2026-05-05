import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
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

@lazySingleton
class ResolveOrdersByStatusUseCase {
  OrdersByStatusLists call({
    required OrderStatus status,
    required List<OrderInfo> orders,
    required OrdersByStatusLists current,
  }) {
    switch (status) {
      case OrderStatus.pending:
        return current.copyWith(pendingOrdersList: orders);
      case OrderStatus.processing:
        return current.copyWith(processingOrdersList: orders);
      case OrderStatus.batched:
        return current.copyWith(batchedOrdersList: orders);
      case OrderStatus.shipping:
        return current.copyWith(deliveringOrdersList: orders);
      case OrderStatus.delayed:
        return current.copyWith(delayedOrdersList: orders);
      case OrderStatus.cancelled:
        return current.copyWith(cancelledOrdersList: orders);
      case OrderStatus.returned:
        return current.copyWith(returnedOrdersList: orders);
      default:
        return current;
    }
  }
}
