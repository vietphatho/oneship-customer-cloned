import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_selected_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

abstract class CreateOrderEvent {
  const CreateOrderEvent();
}

class CreateOrderChangeProductEvent extends CreateOrderEvent {
  final List<ProductEntitySelected> products;

  const CreateOrderChangeProductEvent(this.products);
}

class CreateOrderInitShopEvent extends CreateOrderEvent {
  final ShopEntity shop;

  CreateOrderInitShopEvent(this.shop);
}

class CreateOrderChangeRequestEvent extends CreateOrderEvent {
  final CreateOrderStep step;
  final CreateOrderRequestEntity request;

  const CreateOrderChangeRequestEvent(
    this.request, {
    this.step = CreateOrderStep.timeInfo,
  });
}

class CreateOrderChangePickUpTimeEvent extends CreateOrderEvent {
  final DateTime? pickUpDate;
  final OrderPickUpSession? pickUpSession;

  const CreateOrderChangePickUpTimeEvent({this.pickUpDate, this.pickUpSession});
}

class CreateOrderChangeCustomerInfoEvent extends CreateOrderEvent {
  final String? customerName;
  final String? phoneNumber;
  final String? address;
  final bool? isNewAddress;
  final Province? province;
  final Ward? ward;

  const CreateOrderChangeCustomerInfoEvent({
    this.customerName,
    this.phoneNumber,
    this.address,
    this.isNewAddress,
    this.province,
    this.ward,
  });
}

class CreateOrderChangeOrderInfoEvent extends CreateOrderEvent {
  final int? cod;
  final int? weight;
  final int? length;
  final int? width;
  final int? height;
  final String? note;
  final DeliveryServiceType? deliveryServiceType;

  CreateOrderChangeOrderInfoEvent({
    this.cod,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.note,
    this.deliveryServiceType,
  });
}

class CreateOrderChangeAcceptTermsEvent extends CreateOrderEvent {
  final bool accept;

  CreateOrderChangeAcceptTermsEvent(this.accept);
}

class CreateOrderCreateEvent extends CreateOrderEvent {
  const CreateOrderCreateEvent();
}

class CreateOrderCalculateFeeEvent extends CreateOrderEvent {
  final CalculateDeliveryFeeRequest request;

  CreateOrderCalculateFeeEvent(this.request);
}

class CreateOrderGetRoutingToShopEvent extends CreateOrderEvent {
  final LatLong shopCoor;
  final String destinationRefId;

  CreateOrderGetRoutingToShopEvent({
    required this.shopCoor,
    required this.destinationRefId,
  });
}

class CreateOrderErrorEvent extends CreateOrderEvent {
  final String message;

  CreateOrderErrorEvent(this.message);
}
