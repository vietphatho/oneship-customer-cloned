import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculate_delivery_fee_request.freezed.dart';
part 'calculate_delivery_fee_request.g.dart';

@freezed
abstract class CalculateDeliveryFeeRequest with _$CalculateDeliveryFeeRequest {
  const factory CalculateDeliveryFeeRequest({
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "weight") int? weight,
    @JsonKey(name: "surchargeCodes") @Default([]) List<dynamic> surcharges,
  }) = _CalculateDeliveryFeeRequest;

  factory CalculateDeliveryFeeRequest.fromJson(Map<String, dynamic> json) =>
      _$CalculateDeliveryFeeRequestFromJson(json);
}
