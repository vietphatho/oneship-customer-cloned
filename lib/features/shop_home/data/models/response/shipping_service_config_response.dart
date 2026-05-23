import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_service_config_response.freezed.dart';
part 'shipping_service_config_response.g.dart';

@freezed
abstract class ShippingServiceConfigResponse
    with _$ShippingServiceConfigResponse {
  const factory ShippingServiceConfigResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "serviceLabel") String? serviceLabel,
    @JsonKey(name: "isEnabled") bool? isEnabled,
    @JsonKey(name: "maxWeightKg") int? maxWeightKg,
    @JsonKey(name: "baseFee") int? baseFee,
    @JsonKey(name: "sortOrder") int? sortOrder,
  }) = _ShippingServiceConfigResponse;

  factory ShippingServiceConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingServiceConfigResponseFromJson(json);
}
