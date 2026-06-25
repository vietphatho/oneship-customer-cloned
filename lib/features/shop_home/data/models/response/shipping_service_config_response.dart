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
    @JsonKey(name: "weightOverflow") ShippingServiceOverflow? weightOverflow,
    @JsonKey(name: "distanceOverflow")
    ShippingServiceOverflow? distanceOverflow,
    @JsonKey(name: "pricingMatrix") List<PricingMatrix>? pricingMatrix,
    @JsonKey(name: "coverageRules") List<CoverageRule>? coverageRules,
    @JsonKey(name: "sortOrder") int? sortOrder,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _ShippingService;

  factory ShippingService.fromJson(Map<String, dynamic> json) =>
      _$ShippingServiceFromJson(json);
}

@freezed
abstract class PricingMatrix with _$PricingMatrix {
  const factory PricingMatrix({
    @JsonKey(name: "provinceLevels") List<int>? provinceLevels,
    @JsonKey(name: "wardLevels") List<int>? wardLevels,
    @JsonKey(name: "maxWeightKg") int? maxWeightKg,
    @JsonKey(name: "prices") List<PricingMatrixPrice>? prices,
  }) = _PricingMatrix;

  factory PricingMatrix.fromJson(Map<String, dynamic> json) =>
      _$PricingMatrixFromJson(json);
}

@freezed
abstract class PricingMatrixPrice with _$PricingMatrixPrice {
  const factory PricingMatrixPrice({
    @JsonKey(name: "maxDistanceKm") int? maxDistanceKm,
    @JsonKey(name: "fee") int? fee,
  }) = _PricingMatrixPrice;

  factory PricingMatrixPrice.fromJson(Map<String, dynamic> json) =>
      _$PricingMatrixPriceFromJson(json);
}

@freezed
abstract class ShippingServiceOverflow with _$ShippingServiceOverflow {
  const factory ShippingServiceOverflow({
    @JsonKey(name: "maxWeightKg") int? maxWeightKg,
    @JsonKey(name: "maxDistanceKm") int? maxDistanceKm,
    @JsonKey(name: "fee") int? fee,
  }) = _ShippingServiceOverflow;

  factory ShippingServiceOverflow.fromJson(Map<String, dynamic> json) =>
      _$ShippingServiceOverflowFromJson(json);
}

@freezed
abstract class CoverageRule with _$CoverageRule {
  const factory CoverageRule({
    @JsonKey(name: "label") String? label,
    @JsonKey(name: "provinceLevels") List<int>? provinceLevels,
    @JsonKey(name: "wardLevels") List<int>? wardLevels,
    @JsonKey(name: "maxWeightKg") int? maxWeightKg,
    @JsonKey(name: "maxDistanceKm") int? maxDistanceKm,
    @JsonKey(name: "fee") int? fee,
    @JsonKey(name: "fees", readValue: _readCoverageRuleFees)
    List<CoverageRuleFee>? fees,
    @JsonKey(name: "isEnabled") bool? isEnabled,
  }) = _CoverageRule;

  factory CoverageRule.fromJson(Map<String, dynamic> json) =>
      _$CoverageRuleFromJson(json);
}

@freezed
abstract class CoverageRuleFee with _$CoverageRuleFee {
  const factory CoverageRuleFee({
    @JsonKey(name: "label") String? label,
    @JsonKey(name: "fee") int? fee,
  }) = _CoverageRuleFee;

  factory CoverageRuleFee.fromJson(Map<String, dynamic> json) =>
      _$CoverageRuleFeeFromJson(json);
}

Object? _readCoverageRuleFees(Map json, String key) {
  return json[key] ?? json["feeItems"] ?? json["fee_items"];
}
