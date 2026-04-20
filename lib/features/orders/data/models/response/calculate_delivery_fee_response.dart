import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculate_delivery_fee_response.freezed.dart';
part 'calculate_delivery_fee_response.g.dart';

@freezed
abstract class CalculateDeliveryFeeResponse
    with _$CalculateDeliveryFeeResponse {
  const factory CalculateDeliveryFeeResponse({
    @JsonKey(name: "baseFee") @Default(0) int baseFee,
    @JsonKey(name: "totalSurchargeFee") @Default(0) int totalSurchargeFee,
    @JsonKey(name: "subtotal") @Default(0) int subtotal,
    @JsonKey(name: "deliveryFee") @Default(0) int deliveryFee,
    @JsonKey(name: "grossFee") @Default(0) int grossFee,
    @JsonKey(name: "vat") @Default(0) int vat,
    @JsonKey(name: "vatRate") @Default(0) int vatRate,
    @JsonKey(name: "surcharges") @Default([]) List<dynamic> surcharges,
  }) = _CalculateDeliveryFeeResponse;

  factory CalculateDeliveryFeeResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateDeliveryFeeResponseFromJson(json);
}
