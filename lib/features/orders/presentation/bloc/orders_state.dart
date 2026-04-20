import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersFetchedByStatusState extends OrdersState {
  final Resource<OrdersListResponse> resource;

  OrdersFetchedByStatusState(this.resource);
}
