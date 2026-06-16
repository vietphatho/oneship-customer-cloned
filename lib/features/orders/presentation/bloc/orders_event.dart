import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_filter_panel.dart';

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

class OrderHistoryOpenDetailEvent extends OrdersEvent {
  final OrdersHistoryEntity order;

  const OrderHistoryOpenDetailEvent(this.order);
}

class OrderDeleteEvent extends OrdersEvent {
  final OrderInfo order;

  OrderDeleteEvent(this.order);
}

class OrdersHistoryFetchingByStatusEvent extends OrdersEvent {
  final OrderStatus status;

  const OrdersHistoryFetchingByStatusEvent(this.status);
}

class OrdersHistoryLoadMoreEvent extends OrdersEvent {
  final OrderStatus status;

  const OrdersHistoryLoadMoreEvent(this.status);
}

class OrdersHistoryFilterToggledEvent extends OrdersEvent {
  const OrdersHistoryFilterToggledEvent();
}

class OrdersHistoryFilterAppliedEvent extends OrdersEvent {
  final OrdersHistoryFilters filters;

  const OrdersHistoryFilterAppliedEvent(this.filters);
}

class OrdersHistoryFilterClearedEvent extends OrdersEvent {
  const OrdersHistoryFilterClearedEvent();
}

class ProcessingOrdersFilterAppliedEvent extends OrdersEvent {
  final ProcessingOrdersFilters filters;

  const ProcessingOrdersFilterAppliedEvent(this.filters);
}

class ValidateOrdAtHubEvent extends OrdersEvent {
  final String hubId;
  final String ordId;

  ValidateOrdAtHubEvent({required this.hubId, required this.ordId});
}

class OrdersFetchVisibleSurchargesEvent extends OrdersEvent {
  final String shopId;
  final bool forceRefresh;

  const OrdersFetchVisibleSurchargesEvent({
    required this.shopId,
    this.forceRefresh = false,
  });
}
