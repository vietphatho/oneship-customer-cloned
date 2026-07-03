import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';

part 'create_order_request.freezed.dart';
part 'create_order_request.g.dart';

@freezed
abstract class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    @JsonKey(name: "externalId", includeIfNull: false) String? externalId,
    @JsonKey(
      name: "externalType",
      includeIfNull: false,
      fromJson: _externalTypeFromJson,
      toJson: _externalTypeToJson,
    )
    ExternalType? externalType,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "surchargeCodes") List<String>? surchargeCodes,
    @JsonKey(name: "surchargeValues") Map<String, int>? surchargeValues,
    @JsonKey(name: "orderNumber", includeIfNull: false) String? orderNumber,
    @JsonKey(name: "codAmount") int? codAmount,
    @JsonKey(name: "status", includeIfNull: false) String? status,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "fullAddressOld") String? fullAddressOld,
    @JsonKey(name: "wardCode") String? wardCode,
    @JsonKey(name: "wardName") String? wardName,
    @JsonKey(name: "provinceCode") String? provinceCode,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "isNewAddress") bool? isNewAddress,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "customerName") String? customerName,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "orderItems") String? orderItems,
    @JsonKey(name: "paymentStatus", includeIfNull: false) String? paymentStatus,
    @JsonKey(name: "paymentMethod", includeIfNull: false) String? paymentMethod,
    @JsonKey(name: "packageSize") String? packageSize,
    @JsonKey(name: "shopId", includeIfNull: false) String? shopId,
    @JsonKey(name: "payer") String? payer,
    @JsonKey(name: "agreeTerms") bool? agreeTerms,
    @JsonKey(name: "detail") Detail? detail,
    @JsonKey(name: "selectedProducts") List<SelectedProduct>? selectedProducts,
    @JsonKey(name: "router") CreateOrderRouter? router,
    @JsonKey(name: "hospitalMetadata", includeIfNull: false)
    HospitalMetadata? hospitalMetadata,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}

ExternalType? _externalTypeFromJson(String? value) {
  for (final type in ExternalType.values) {
    if (type.value == value) return type;
  }
  return null;
}

String? _externalTypeToJson(ExternalType? type) => type?.value;

@freezed
abstract class HospitalMetadata with _$HospitalMetadata {
  const factory HospitalMetadata({
    @JsonKey(name: "medicalRecordCode") String? medicalRecordCode,
    @JsonKey(name: "prescriptionDate") String? prescriptionDate,
    @JsonKey(name: "prescriptionNumber") String? prescriptionNumber,
    @JsonKey(name: "delegateName") String? delegateName,
    @JsonKey(name: "delegatePhone") String? delegatePhone,
  }) = _HospitalMetadata;

  factory HospitalMetadata.fromJson(Map<String, dynamic> json) =>
      _$HospitalMetadataFromJson(json);
}

@freezed
abstract class Detail with _$Detail {
  const factory Detail({
    // @JsonKey(name: "pickupDate") DateTime? pickupDate,
    // @JsonKey(name: "pickupTimeSlot") String? pickupTimeSlot,
    // @JsonKey(name: "deliveryTimeSlot") String? deliveryTimeSlot,
    @JsonKey(name: "weight") double? weight,
    // @JsonKey(name: "isHighValueGoods") bool? isHighValueGoods,
    // @JsonKey(name: "isFragile") bool? isFragile,
    // @JsonKey(name: "isOnePiece") bool? isOnePiece,
    // @JsonKey(name: "isLiquid") bool? isLiquid,
    // @JsonKey(name: "hasBattery") bool? hasBattery,
    @JsonKey(name: "commodityType") @Default([]) List<String> commodityType,
    @JsonKey(name: "handlingType") @Default([]) List<String> handlingType,
    // @JsonKey(name: "length") @Default(0) int length,
    // @JsonKey(name: "width") @Default(0) int width,
    // @JsonKey(name: "height") @Default(0) int height,
    // @JsonKey(name: "orderSource") String? orderSource,
    @JsonKey(name: "note") String? note,
  }) = _Detail;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
}

@freezed
abstract class CreateOrderRouter with _$CreateOrderRouter {
  const factory CreateOrderRouter({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "time") int? time,
    @JsonKey(name: "bbox") List<double>? bbox,
    @JsonKey(name: "orderCoordinates") List<double>? orderCoordinates,
    @JsonKey(name: "fullRouteData") FullRouteData? fullRouteData,
  }) = _CreateOrderRouter;

  factory CreateOrderRouter.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRouterFromJson(json);
}

@freezed
abstract class FullRouteData with _$FullRouteData {
  const factory FullRouteData() = _FullRouteData;

  factory FullRouteData.fromJson(Map<String, dynamic> json) =>
      _$FullRouteDataFromJson(json);
}

@freezed
abstract class SelectedProduct with _$SelectedProduct {
  const factory SelectedProduct({
    @JsonKey(name: "productId") String? id,
    @JsonKey(name: "productName") String? name,
    @JsonKey(name: "productSku") String? sku,
    @JsonKey(name: "unitPrice") int? price,
    @JsonKey(name: "quantity") int? qty,
    @JsonKey(name: "discountAmount") int? discountAmount,
  }) = _SelectedProduct;

  factory SelectedProduct.fromJson(Map<String, dynamic> json) =>
      _$SelectedProductFromJson(json);
}
