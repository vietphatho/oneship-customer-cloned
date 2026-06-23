import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

part 'create_order_state.freezed.dart';

@freezed
abstract class CreateOrderState with _$CreateOrderState {
  const CreateOrderState._();

  const factory CreateOrderState({
    @Default(CreateOrderStep.receiverInfo) CreateOrderStep step,
    required CreateOrderRequestEntity request,
    required CreateOrderRequestEntity draftRequest,
    required List<SelectedProductEntity> productEntitySelected,
    required BriefShopEntity shopInfo,
    required Resource<GetRoutingToShopResponse> routingToShopResource,
    @Default([]) List<String> selectedSurchargeCodes,
    @Default({}) Map<String, int> surchargeInputValues,
    @Default({}) Map<String, String> surchargeValidationErrors,
    Resource<CalculatedDeliveryFeeEntity>? calculatedFeeResource,
    Resource? createOrderResource,
    @Default(false) bool acceptTerms,
    @Default(false) bool canCalculateFee,
    String? errorMessage,
    String? updateOrdId,
  }) = _CreateOrderState;

  factory CreateOrderState.initial() => CreateOrderState(
    request: CreateOrderRequestEntity.empty(),
    draftRequest: CreateOrderRequestEntity.empty(),
    shopInfo: const BriefShopEntity(),
    routingToShopResource: Resource.loading(),
    productEntitySelected: const [],
  );

  bool get isEnableAddressField =>
      draftRequest.province != null && draftRequest.ward != null;

  num get codAmount {
    return surchargeInputValues['COD'] ?? 0;
  }

  num get totalCollectAmount {
    if (draftRequest.payer == Payer.sender) {
      return codAmount;
    } else {
      return codAmount + (calculatedFeeResource?.data?.deliveryFee ?? 0);
    }
  }
}
