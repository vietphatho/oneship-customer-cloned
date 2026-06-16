import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

abstract class CreateOrderEvent {
  const CreateOrderEvent();
}

// class CreateOrderChangeProductEvent extends CreateOrderEvent {
//   final List<SelectedProductEntity> products;

//   const CreateOrderChangeProductEvent(this.products);
// }

class CreateOrderInitShopEvent extends CreateOrderEvent {
  final BriefShopEntity shop;

  CreateOrderInitShopEvent(this.shop);
}

class CreateOrderVisibleSurchargesChangedEvent extends CreateOrderEvent {
  final Resource<List<SurchargeGroupEntity>> resource;

  const CreateOrderVisibleSurchargesChangedEvent(this.resource);
}

class UpdateOrderInitEvent extends CreateOrderEvent {
  final String ordId;
  final CreateOrderRequestEntity request;

  const UpdateOrderInitEvent({required this.ordId, required this.request});
}

class CreateOrderChangeRequestEvent extends CreateOrderEvent {
  final CreateOrderStep step;
  final CreateOrderRequestEntity request;

  const CreateOrderChangeRequestEvent(
    this.request, {
    this.step = CreateOrderStep.receiverInfo,
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
  final PackageSize? packageSize;
  final String? note;
  final ShippingServiceConfigEntity? serviceConfig;

  CreateOrderChangeOrderInfoEvent({
    this.cod,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.packageSize,
    this.note,
    this.serviceConfig,
  });
}

class CreateOrderChangeAcceptTermsEvent extends CreateOrderEvent {
  final bool accept;

  CreateOrderChangeAcceptTermsEvent(this.accept);
}

class CreateOrderToggleSurchargeEvent extends CreateOrderEvent {
  final String code;
  final bool isSelected;

  const CreateOrderToggleSurchargeEvent({
    required this.code,
    required this.isSelected,
  });
}

class CreateOrderUpdateSurchargeValueEvent extends CreateOrderEvent {
  final String code;
  final int? value;

  const CreateOrderUpdateSurchargeValueEvent({
    required this.code,
    required this.value,
  });
}

class CreateOrderSurchargeValidationChangedEvent extends CreateOrderEvent {
  final Map<String, String> errors;

  const CreateOrderSurchargeValidationChangedEvent(this.errors);
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
