import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';

part 'order_detail_response.freezed.dart';
part 'order_detail_response.g.dart';

@freezed
abstract class OrderDetailResponse with _$OrderDetailResponse {
  const factory OrderDetailResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "externalOrderId") String? externalOrderId,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "trackingCode") String? trackingCode,
    @JsonKey(name: "sequenceDate") DateTime? sequenceDate,
    @JsonKey(name: "dailySequence") int? dailySequence,
    @JsonKey(name: "totalDiscountAmount") int? totalDiscountAmount,
    @JsonKey(name: "totalFeeAmount") int? totalFeeAmount,
    @JsonKey(name: "codAmount") int? codAmount,
    @JsonKey(name: "collectAmount") int? collectAmount,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "statusUpdateTime") DateTime? statusUpdateTime,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "fullAddressOld") String? fullAddressOld,
    @JsonKey(name: "wardCode") int? wardCode,
    @JsonKey(name: "wardName") String? wardName,
    @JsonKey(name: "provinceCode") int? provinceCode,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "customerName") String? customerName,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "packageType") String? packageType,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
    @JsonKey(name: "coordinates") BaseCoordinates? coordinates,
    @JsonKey(name: "distance") String? distance,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "payer") String? payer,
    @JsonKey(name: "isReturnOrder") bool? isReturnOrder,
    @JsonKey(name: "createdByUserId") String? createdByUserId,
    @JsonKey(name: "shipperCodes") List<dynamic>? shipperCodes,
    @JsonKey(name: "detail") Detail? detail,
    @JsonKey(name: "items") List<OrderDetailProductResponse>? items,
    @JsonKey(name: "shop") Shop? shop,
    @JsonKey(name: "orderFees") List<OrderFee>? orderFees,
    @JsonKey(name: "totalProductAmount") int? totalProductAmount,
    @JsonKey(name: "totalDeliveryFee") int? totalDeliveryFee,
  }) = _OrderDetailResponse;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailResponseFromJson(json);
}

@freezed
abstract class Detail with _$Detail {
  const factory Detail({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "pickupDate") DateTime? pickupDate,
    @JsonKey(name: "pickupTimeSlot") String? pickupTimeSlot,
    @JsonKey(name: "deliveryTimeSlot") dynamic deliveryTimeSlot,
    @JsonKey(name: "weight") String? weight,
    @JsonKey(name: "length") String? length,
    @JsonKey(name: "width") String? width,
    @JsonKey(name: "height") String? height,
    @JsonKey(name: "isFragile") bool? isFragile,
    @JsonKey(name: "isLiquid") bool? isLiquid,
    @JsonKey(name: "hasBattery") bool? hasBattery,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _Detail;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
}

@freezed
abstract class OrderFee with _$OrderFee {
  const factory OrderFee({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "feeGroup") String? feeGroup,
    @JsonKey(name: "feeSubtype") dynamic feeSubtype,
    @JsonKey(name: "baseAmount") int? baseAmount,
    @JsonKey(name: "vatRate") int? vatRate,
    @JsonKey(name: "vatAmount") int? vatAmount,
    @JsonKey(name: "totalAmount") int? totalAmount,
    @JsonKey(name: "snapshot") dynamic snapshot,
    @JsonKey(name: "createdAt") DateTime? createdAt,
  }) = _OrderFee;

  factory OrderFee.fromJson(Map<String, dynamic> json) =>
      _$OrderFeeFromJson(json);
}

@freezed
abstract class Shop with _$Shop {
  const factory Shop({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "profile") Profile? profile,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "fullAddress") String? fullAddress,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
abstract class OrderDetailProductResponse with _$OrderDetailProductResponse {
  const factory OrderDetailProductResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "productSku") String? productSku,
    @JsonKey(name: "variantId") dynamic variantId,
    @JsonKey(name: "variantName") dynamic variantName,
    @JsonKey(name: "variantAttributes") dynamic variantAttributes,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "unitPrice") int? unitPrice,
    @JsonKey(name: "discountAmount") int? discountAmount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
  }) = _OrderDetailProductResponse;

  factory OrderDetailProductResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailProductResponseFromJson(json);
}
