import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';

part 'order_tracking_response.freezed.dart';
part 'order_tracking_response.g.dart';

@freezed
abstract class OrderTrackingResponse with _$OrderTrackingResponse {
  const factory OrderTrackingResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "trackingCode") String? trackingCode,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "codAmount") double? codAmount,
    @JsonKey(name: "totalDeliveryFee") double? totalDeliveryFee,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "weight") int? weight,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "shipper") Shipper? shipper,
    @JsonKey(name: "deliveryHistory") List<DeliveryHistory>? deliveryHistory,
    @JsonKey(name: "shopInfo") ShopInfo? shopInfo,
    @JsonKey(name: "customer") Customer? customer,
    @JsonKey(name: "collectAmount") int? collectAmount,
    @JsonKey(name: "coordinates") BaseCoordinates? coordinates,
  }) = _OrderTrackingResponse;

  factory OrderTrackingResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingResponseFromJson(json);
}

@freezed
abstract class DeliveryHistory with _$DeliveryHistory {
  const factory DeliveryHistory({
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "confirmationImages") List<String>? confirmationImages,
    @JsonKey(name: "arrivedAtDelivery") DateTime? arrivedAtDelivery,
    @JsonKey(name: "deliveredAt") DateTime? deliveredAt,
    @JsonKey(name: "addedToPackageAt") DateTime? addedToPackageAt,
    @JsonKey(name: "scannedAt") DateTime? scannedAt,
    @JsonKey(name: "pickupConfirmedAt") DateTime? pickupConfirmedAt,
    @JsonKey(name: "quantityConfirmedAt") DateTime? quantityConfirmedAt,
    @JsonKey(name: "pickupImages") List<String>? pickupImages,
    @JsonKey(name: "isVerified") bool? isVerified,
  }) = _DeliveryHistory;

  factory DeliveryHistory.fromJson(Map<String, dynamic> json) =>
      _$DeliveryHistoryFromJson(json);
}

@freezed
abstract class Shipper with _$Shipper {
  const factory Shipper({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "shipperCodes") String? shipperCodes,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "avatarUrl") String? avatarUrl,
    @JsonKey(name: "coordinate") BaseCoordinates? coordinates,
  }) = _Shipper;

  factory Shipper.fromJson(Map<String, dynamic> json) =>
      _$ShipperFromJson(json);
}

@freezed
abstract class ShopInfo with _$ShopInfo {
  const factory ShopInfo({
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "shopPhone") String? shopPhone,
    @JsonKey(name: "coordinate") BaseCoordinates? coordinate,
  }) = _ShopInfo;

  factory ShopInfo.fromJson(Map<String, dynamic> json) =>
      _$ShopInfoFromJson(json);
}

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    @JsonKey(name: "customerName") String? customerName,
    @JsonKey(name: "customerPhone") String? customerPhone,
    @JsonKey(name: "customerFullAddress") String? customerFullAddress,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
