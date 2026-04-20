import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_tracking_response.freezed.dart';
part 'order_tracking_response.g.dart';

@freezed
abstract class OrderTrackingResponse with _$OrderTrackingResponse {
  const factory OrderTrackingResponse({
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "trackingCode") String? trackingCode,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "weight") int? weight,
    @JsonKey(name: "shipper") Shipper? shipper,
    @JsonKey(name: "deliveryHistory") List<DeliveryHistory>? deliveryHistory,
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
  }) = _Shipper;

  factory Shipper.fromJson(Map<String, dynamic> json) =>
      _$ShipperFromJson(json);
}
