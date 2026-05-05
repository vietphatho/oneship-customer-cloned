import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';

part 'orders_state.freezed.dart';

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    required Resource<OrdersListResponse> orderListByStatusResource,
    required Resource<OrdersHistoryEntity> ordersHistoryResource,
    required Resource<OrderDetailEntity> orderDetailResource,
    required Resource deleteOrderResource,
    @Default([]) List<OrderInfo> pendingOrdersList,
    @Default([]) List<OrderInfo> processingOrdersList,
    @Default([]) List<OrderInfo> batchedOrdersList,
    @Default([]) List<OrderInfo> deliveringOrdersList,
    @Default([]) List<OrderInfo> delayedOrdersList,
    @Default([]) List<OrderInfo> cancelledOrdersList,
    @Default([]) List<OrderInfo> returnedOrdersList,
    @Default([]) List<OrderHistoryInfoEntity> deliveredOrdersHistoryList,
    @Default([]) List<OrderHistoryInfoEntity> returnedOrdersHistoryList,
    @Default([]) List<OrderHistoryInfoEntity> filteredDeliveredOrdersHistoryList,
    @Default([]) List<OrderHistoryInfoEntity> filteredReturnedOrdersHistoryList,
    @Default([]) List<OrderHistoryInfoEntity> visibleDeliveredOrdersHistoryList,
    @Default([]) List<OrderHistoryInfoEntity> visibleReturnedOrdersHistoryList,
    @Default(1000000) double ordersHistoryMaxCodAmount,
    @Default(false) bool showOrdersHistoryFilters,
    @Default(OrdersHistoryFilters()) OrdersHistoryFilters ordersHistoryFilters,
  }) = _OrdersState;
}
