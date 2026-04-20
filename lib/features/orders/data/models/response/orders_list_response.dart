import 'package:freezed_annotation/freezed_annotation.dart';
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
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "ward") int? ward,
    @JsonKey(name: "city") int? city,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
    @JsonKey(name: "packageType") String? packageType,
    @JsonKey(name: "payer") String? payer,
    @JsonKey(name: "deliveryFee") int? deliveryFee,
    @JsonKey(name: "vat") int? vat,
    @JsonKey(name: "vatRate") int? vatRate,
    @JsonKey(name: "codAmount") int? codAmount,
    @JsonKey(name: "totalAmount") int? totalAmount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "shop") ShopOfOrder? shop,
  }) = _OrderInfo;

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoFromJson(json);
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
