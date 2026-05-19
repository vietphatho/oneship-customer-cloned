import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_by_status_lists.dart';

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

  OrdersByStatusLists append({
    required OrderStatus status,
    required List<OrderInfo> orders,
    required OrdersByStatusLists current,
  }) {
    switch (status) {
      case OrderStatus.pending:
        return current.copyWith(
          pendingOrdersList: [...current.pendingOrdersList, ...orders],
        );
      case OrderStatus.processing:
        return current.copyWith(
          pendingOrdersList: [...current.processingOrdersList, ...orders],
        );
      case OrderStatus.batched:
        return current.copyWith(
          pendingOrdersList: [...current.batchedOrdersList, ...orders],
        );
      case OrderStatus.shipping:
        return current.copyWith(
          pendingOrdersList: [...current.deliveringOrdersList, ...orders],
        );
      case OrderStatus.delayed:
        return current.copyWith(
          pendingOrdersList: [...current.delayedOrdersList, ...orders],
        );
      case OrderStatus.cancelled:
        return current.copyWith(
          pendingOrdersList: [...current.cancelledOrdersList, ...orders],
        );
      case OrderStatus.returned:
        return current.copyWith(
          pendingOrdersList: [...current.returnedOrdersList, ...orders],
        );
      default:
        return current;
    }
  }
}
