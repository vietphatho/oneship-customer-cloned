import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculate_delivery_fee_response.freezed.dart';
part 'calculate_delivery_fee_response.g.dart';

@freezed
abstract class CalculateDeliveryFeeResponse
    with _$CalculateDeliveryFeeResponse {
  const factory CalculateDeliveryFeeResponse({
    @JsonKey(name: "baseFee") Fee? baseFee,
    @JsonKey(name: "surchargesFee") Fee? surchargesFee,
    @JsonKey(name: "deliveryFee") int? deliveryFee,
    @JsonKey(name: "surcharges") List<dynamic>? surcharges,
  }) = _CalculateDeliveryFeeResponse;

  factory CalculateDeliveryFeeResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateDeliveryFeeResponseFromJson(json);
}

@freezed
abstract class Fee with _$Fee {
  const factory Fee({
    @JsonKey(name: "originalAmount") int? originalAmount,
    @JsonKey(name: "vatRate") int? vatRate,
    @JsonKey(name: "vatAmount") int? vatAmount,
    @JsonKey(name: "totalAmount") int? totalAmount,
    @JsonKey(name: "currency") String? currency,
  }) = _Fee;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
}
