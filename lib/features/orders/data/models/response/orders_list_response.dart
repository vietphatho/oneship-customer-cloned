import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'orders_list_response.freezed.dart';
part 'orders_list_response.g.dart';

@freezed
abstract class OrdersListResponse with _$OrdersListResponse {
  const factory OrdersListResponse({
    @JsonKey(name: "items") List<OrderInfo>? data,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _OrdersListResponse;

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersListResponseFromJson(json);
}

@freezed
abstract class OrderInfo with _$OrderInfo {
  const factory OrderInfo({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "trackingCode") String? trackingCode,
    @JsonKey(name: "customerName") String? customerName,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "wardCode") int? wardCode,
    @JsonKey(name: "provinceCode") int? provinceCode,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
    @JsonKey(name: "packageType") String? packageType,
    @JsonKey(name: "payer") String? payer,
    @JsonKey(name: "codAmount") int? codAmount,
    @JsonKey(name: "collectAmount") int? collectAmount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "externalOrderId") String? externalOrderId,
    @JsonKey(name: "sequenceDate") String? sequenceDate,
    @JsonKey(name: "dailySequence") int? dailySequence,
    @JsonKey(name: "totalProductAmount") int? totalProductAmount,
    @JsonKey(name: "totalDiscountAmount") int? totalDiscountAmount,
    @JsonKey(name: "totalFeeAmount") int? totalFeeAmount,
    @JsonKey(name: "totalDeliveryFee") int? totalDeliveryFee,
    @JsonKey(name: "createdByUserId") String? createdByUserId,
    @JsonKey(name: "statusUpdateTime") DateTime? statusUpdateTime,
    @JsonKey(name: "fullAddressOld") String? fullAddressOld,
    @JsonKey(name: "wardName") String? wardName,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "coordinates") BaseCoordinates? coordinates,
    @JsonKey(name: "distance") String? distance,
    @JsonKey(name: "isReturnOrder") bool? isReturnOrder,
    @JsonKey(name: "userCodes") List<String>? userCodes,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "orderFees") List<OrderFee>? orderFees,
    @JsonKey(name: "shop") ShopOfOrder? shop,
  }) = _OrderInfo;

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoFromJson(json);
}

@freezed
abstract class OrderFee with _$OrderFee {
  const factory OrderFee({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "feeGroup") String? feeGroup,
    @JsonKey(name: "feeSubtype") String? feeSubtype,
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
abstract class ShopOfOrder with _$ShopOfOrder {
  const factory ShopOfOrder({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopName") String? shopName,
  }) = _ShopOfOrder;

  factory ShopOfOrder.fromJson(Map<String, dynamic> json) =>
      _$ShopOfOrderFromJson(json);
}
