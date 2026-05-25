import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_service_config_response.freezed.dart';
part 'shipping_service_config_response.g.dart';

@freezed
abstract class ShippingServiceConfigResponse
    with _$ShippingServiceConfigResponse {
  const factory ShippingServiceConfigResponse({
    @JsonKey(name: "data") List<ShippingService>? data,
  }) = _ShippingServiceConfigResponse;

  factory ShippingServiceConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingServiceConfigResponseFromJson(json);
}

@freezed
abstract class ShippingService with _$ShippingService {
  const factory ShippingService({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "serviceLabel") String? serviceLabel,
    @JsonKey(name: "isEnabled") bool? isEnabled,
    @JsonKey(name: "maxWeightKg") int? maxWeightKg,
    @JsonKey(name: "baseFee") int? baseFee,
    @JsonKey(name: "distanceTiers") List<DistanceTier>? distanceTiers,
    @JsonKey(name: "weightTiers") List<WeightTier>? weightTiers,
    @JsonKey(name: "sortOrder") int? sortOrder,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _ShippingService;

  factory ShippingService.fromJson(Map<String, dynamic> json) =>
      _$ShippingServiceFromJson(json);
}

@freezed
abstract class DistanceTier with _$DistanceTier {
  const factory DistanceTier({
    @JsonKey(name: "fromKm") int? fromKm,
    @JsonKey(name: "fee") int? fee,
  }) = _DistanceTier;

  factory DistanceTier.fromJson(Map<String, dynamic> json) =>
      _$DistanceTierFromJson(json);
}

@freezed
abstract class WeightTier with _$WeightTier {
  const factory WeightTier({
    @JsonKey(name: "fromKg") int? fromKg,
    @JsonKey(name: "fee") int? fee,
  }) = _WeightTier;

  factory WeightTier.fromJson(Map<String, dynamic> json) =>
      _$WeightTierFromJson(json);
}
