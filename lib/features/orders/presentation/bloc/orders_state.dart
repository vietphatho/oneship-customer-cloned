import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';

part 'orders_state.freezed.dart';

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    required Resource<OrdersListResponse> orderListByStatusResource,
    required Resource<OrderDetailEntity> orderDetailResource,
    @Default([]) List<OrderInfo> pendingOrdersList,
    @Default([]) List<OrderInfo> processingOrdersList,
    @Default([]) List<OrderInfo> batchedOrdersList,
    @Default([]) List<OrderInfo> deliveringOrdersList,
    @Default([]) List<OrderInfo> delayedOrdersList,
    @Default([]) List<OrderInfo> cancelledOrdersList,
    @Default([]) List<OrderInfo> returnedOrdersList,
  }) = _OrdersState;
}
