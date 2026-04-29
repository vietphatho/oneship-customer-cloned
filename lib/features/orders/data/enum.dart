import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/batched_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/canceled_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/delayed_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/delivering_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/pending_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_list_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/returned_orders_list_view.dart';


enum CreateOrderProductAction { increment, decrement }

enum OrderStatus {
  pending,
  processing,
  batched,
  shipping,
  delayed,
  delivered,
  cancelled,
  deleted,
  returned,
  returnInProgress,
  waitingHubVerify,
  allProcessing,
}

extension OrderStatusExt on OrderStatus {
  static const _mapValue = {
    OrderStatus.pending: "pending",
    OrderStatus.processing: "processing",
    OrderStatus.batched: "batched",
    OrderStatus.shipping: "shipping",
    OrderStatus.delayed: "delayed",
    OrderStatus.delivered: "delivered",
    OrderStatus.cancelled: "cancelled",
    OrderStatus.deleted: "deleted",
    OrderStatus.returned: "returned",
    OrderStatus.returnInProgress: "return_in_progress",
    OrderStatus.waitingHubVerify: "waiting_hub_verify",
    OrderStatus.allProcessing: "all_processing",
  };

  static const _mapView = {
    OrderStatus.pending: PendingOrdersListView(),
    OrderStatus.processing: ProcessingOrdersListView(),
    OrderStatus.batched: BatchedOrdersListView(),
    OrderStatus.shipping: DeliveringOrdersListView(),
    OrderStatus.delayed: DelayedOrdersListView(),
    OrderStatus.delivered: SizedBox(),
    OrderStatus.cancelled: CanceledOrdersListView(),
    OrderStatus.deleted: SizedBox(),
    OrderStatus.returned: ReturnedOrdersListView(),
    OrderStatus.returnInProgress: SizedBox(),
    OrderStatus.waitingHubVerify: SizedBox(),
    OrderStatus.allProcessing: SizedBox(),
  };

  String get value => _mapValue[this]!;

  Widget get view => _mapView[this]!;
}

enum OrderTrackingStatus {
  delivered,
  arrivedAtDelivery,
  pickedUp,
  confirmQty,
  arrivedAtShop,
  packed,
}

extension OrderTrackingStatusExt on OrderTrackingStatus {
  static const _mapName = {
    OrderTrackingStatus.delivered: "delivered",
    OrderTrackingStatus.arrivedAtDelivery: "arrived_at_delivery",
    OrderTrackingStatus.pickedUp: "picked_up",
    OrderTrackingStatus.confirmQty: "confirm_qty",
    OrderTrackingStatus.arrivedAtShop: "arrived_at_shop",
    OrderTrackingStatus.packed: "packed",
  };

  static const _mapDesc = {
    OrderTrackingStatus.delivered: "delivered_desc",
    OrderTrackingStatus.arrivedAtDelivery: "arrived_at_delivery_desc",
    OrderTrackingStatus.pickedUp: "picked_up_desc",
    OrderTrackingStatus.confirmQty: "confirm_qty_desc",
    OrderTrackingStatus.arrivedAtShop: "arrived_at_shop_desc",
    OrderTrackingStatus.packed: "packed_desc",
  };

  String get statusName => _mapName[this]!;

  String get description => _mapDesc[this]!;
}

enum CreateOrderStep { timeInfo, receiverInfo, orderInfo, confirmation }

enum OrderPickUpSession { morning, afternoon }

extension OrderPickUpSessionExt on OrderPickUpSession {
  static final _mapValue = {
    OrderPickUpSession.morning: "08:00 - 12:00",
    OrderPickUpSession.afternoon: "14:00 - 18:00",
  };

  static final _mapLabel = {
    OrderPickUpSession.morning: "Sáng (8:00-12:00)",
    OrderPickUpSession.afternoon: "Chiều (14:00-18:00)",
  };

  String get requestValue => _mapValue[this]!;

  String get label => _mapLabel[this]!;
}

enum CreateOrderPayer { sender, recipient }

extension CreateOrderPayerExt on CreateOrderPayer {
  static final _mapValue = {
    CreateOrderPayer.sender: "SENDER",
    CreateOrderPayer.recipient: "RECEIVER",
  };

  String get requestValue => _mapValue[this]!;
}

enum DeliveryServiceType { express, standard }

extension DeliveryServiceTypeExt on DeliveryServiceType {
  static final _mapValue = {
    DeliveryServiceType.express: "ht",
    DeliveryServiceType.standard: "ts1",
  };

  static final _mapName = {
    DeliveryServiceType.express: "express",
    DeliveryServiceType.standard: "standard",
  };

  static final _mapDescription = {
    DeliveryServiceType.express: "express_des",
    DeliveryServiceType.standard: "standard_des",
  };

  String get requestValue => _mapValue[this]!;

  String get nameValue => _mapName[this]!;

  String get description => _mapDescription[this]!;
}

enum Payer { sender, recipient }

extension PayerExt on Payer {
  static final _mapValue = {
    Payer.sender: "sender",
    Payer.recipient: "receiver",
  };

  static final _mapName = {
    Payer.sender: "sender",
    Payer.recipient: "recipient",
  };

  String get requestValue => _mapValue[this]!;

  String get nameValue => _mapName[this]!;
}

enum OrderDetailTab { info, products, transHistory }
