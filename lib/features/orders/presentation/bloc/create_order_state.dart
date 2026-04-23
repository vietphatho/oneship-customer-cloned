import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

abstract class CreateOrderState {
  const CreateOrderState({
    this.step = CreateOrderStep.timeInfo,
    required this.request,
    required this.draftRequest,
    required this.shopInfo,
    required this.routingToShopResource,
  });

  final CreateOrderStep step;
  final CreateOrderRequestEntity request;
  final CreateOrderRequestEntity draftRequest;
  final ShopEntity shopInfo;
  final Resource<GetRoutingToShopResponse> routingToShopResource;

  bool get isEnableAddressField =>
      draftRequest.province != null && draftRequest.ward != null;
}

class CreateOrderRequestChangedState extends CreateOrderState {
  CreateOrderRequestChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step,
  });
}

class CreateOrderPickUpTimeChangedState extends CreateOrderState {
  final DateTime? pickUpDate;
  final OrderPickUpSession? pickUpSession;

  CreateOrderPickUpTimeChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    this.pickUpDate,
    this.pickUpSession,
  });
}

class CreateOrderCustomerInfoChangedState extends CreateOrderState {
  CreateOrderCustomerInfoChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step = CreateOrderStep.receiverInfo,
  });
}

class CreateOrderInfoChangedState extends CreateOrderState {
  CreateOrderInfoChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step = CreateOrderStep.orderInfo,
  });
}

class CreateOrderCalculatedFeeState extends CreateOrderState {
  final Resource<CalculatedDeliveryFeeEntity> resource;

  CreateOrderCalculatedFeeState(
    this.resource, {
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
  });
}

class CreateOrderCreatedState extends CreateOrderState {
  final Resource resource;

  CreateOrderCreatedState(
    this.resource, {
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
  });
}

class CreateOrderGetRoutingToShopState extends CreateOrderState {
  CreateOrderGetRoutingToShopState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
  });
}
