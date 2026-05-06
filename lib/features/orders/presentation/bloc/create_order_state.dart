import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_selected_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

abstract class CreateOrderState {
  const CreateOrderState({
    this.step = CreateOrderStep.timeInfo,
    required this.request,
    required this.draftRequest,
    required this.productEntitySelected,
    required this.shopInfo,
    required this.routingToShopResource,
    this.acceptTerms = true,
    this.errorMessage,
  });

  final CreateOrderStep step;
  final CreateOrderRequestEntity request;
  final CreateOrderRequestEntity draftRequest;
  final List<ProductEntitySelected> productEntitySelected;
  final ShopEntity shopInfo;
  final Resource<GetRoutingToShopResponse> routingToShopResource;
  final bool acceptTerms;
  final String? errorMessage;

  bool get isEnableAddressField =>
      draftRequest.province != null && draftRequest.ward != null;
}

class CreateOrderProductChangedState extends CreateOrderState {
  CreateOrderProductChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step,
    required super.productEntitySelected,
  });
}

class CreateOrderRequestChangedState extends CreateOrderState {
  CreateOrderRequestChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.acceptTerms,
    super.step,
    required super.productEntitySelected,
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
    required super.productEntitySelected,
  });
}

class CreateOrderCustomerInfoChangedState extends CreateOrderState {
  CreateOrderCustomerInfoChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step = CreateOrderStep.receiverInfo,
    required super.productEntitySelected,
  });
}

class CreateOrderInfoChangedState extends CreateOrderState {
  CreateOrderInfoChangedState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    super.step = CreateOrderStep.orderInfo,
    required super.productEntitySelected,
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
    required super.productEntitySelected,
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
    required super.productEntitySelected,
    super.acceptTerms,
  });
}

class CreateOrderGetRoutingToShopState extends CreateOrderState {
  CreateOrderGetRoutingToShopState({
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    required super.productEntitySelected,
    super.acceptTerms,
  });
}

class CreateOrderErrorState extends CreateOrderState {
  CreateOrderErrorState({
    required String errorMessage,
    required super.request,
    required super.draftRequest,
    required super.shopInfo,
    required super.routingToShopResource,
    required super.productEntitySelected,
    super.acceptTerms,
    super.step,
  }) : super(errorMessage: errorMessage);
}

extension CreateOrderStateX on CreateOrderState {
  int getCalculatedTotalQuantity() {
    int totalQuantity = 0;

    for (var pro in productEntitySelected) {
      totalQuantity += pro.quantity;
    }

    return totalQuantity;
  }

  int getCalculatedTotalAmount() {
    int totalAmount = 0;

    for (var pro in productEntitySelected) {
      totalAmount += pro.calculatedTotalAmount;
    }

    return totalAmount;
  }
}
