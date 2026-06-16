import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/surcharge_entity.dart';
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
    required Resource<List<SurchargeGroupEntity>> surchargeGroupsResource,
    @Default([]) List<String> selectedSurchargeCodes,
    @Default({}) Map<String, int> surchargeInputValues,
    @Default({}) Map<String, String> surchargeValidationErrors,
    Resource<CalculatedDeliveryFeeEntity>? calculatedFeeResource,
    Resource? createOrderResource,
    @Default(true) bool acceptTerms,
    String? errorMessage,
    String? updateOrdId,
  }) = _CreateOrderState;

  factory CreateOrderState.initial() => CreateOrderState(
    request: CreateOrderRequestEntity.empty(),
    draftRequest: CreateOrderRequestEntity.empty(),
    shopInfo: const BriefShopEntity(),
    routingToShopResource: Resource.loading(),
    surchargeGroupsResource: Resource.loading(data: const []),
    productEntitySelected: const [],
  );

  bool get isEnableAddressField =>
      draftRequest.province != null && draftRequest.ward != null;

  bool get isLoadingSurcharges =>
      surchargeGroupsResource.state == Result.loading;

  List<SurchargeGroupEntity> get surchargeGroups =>
      surchargeGroupsResource.data ?? const [];

  List<SurchargeEntity> get surcharges => surchargeGroups
      .expand((group) => group.surcharges)
      .where((surcharge) => surcharge.isEnabled && surcharge.isVisibleOnShop)
      .toList();

  Map<String, int> get selectedSurchargeValues {
    final values = <String, int>{};
    for (final surcharge in surcharges) {
      if (!selectedSurchargeCodes.contains(surcharge.code)) continue;
      if (!surcharge.requiresValue) continue;
      final value = surchargeInputValues[surcharge.code];
      if (value != null) values[surcharge.code] = value;
    }
    return values;
  }

  List<SelectedSurchargeEntity> get selectedSurchargeDisplays {
    final displays = <SelectedSurchargeEntity>[];
    for (final surcharge in surcharges) {
      if (!selectedSurchargeCodes.contains(surcharge.code)) continue;
      displays.add(
        SelectedSurchargeEntity(
          code: surcharge.code,
          label: surcharge.label,
          value: surcharge.requiresValue
              ? surchargeInputValues[surcharge.code]
              : null,
        ),
      );
    }
    return displays;
  }

  bool get hasInvalidSelectedSurcharges {
    for (final surcharge in surcharges) {
      if (!selectedSurchargeCodes.contains(surcharge.code)) continue;
      if (!surcharge.requiresValue) continue;
      if (!surcharge.isValidValue(surchargeInputValues[surcharge.code])) {
        return true;
      }
    }
    return false;
  }

  SurchargeEntity? findSurcharge(String code) {
    return surcharges.firstWhereOrNull((surcharge) => surcharge.code == code);
  }

  num get codAmount {
    return selectedSurchargeValues['COD'] ?? 0;
  }

  num get totalCollectAmount {
    if (draftRequest.payer == Payer.sender) {
      return codAmount;
    } else {
      return codAmount + (calculatedFeeResource?.data?.deliveryFee ?? 0);
    }
  }
}
