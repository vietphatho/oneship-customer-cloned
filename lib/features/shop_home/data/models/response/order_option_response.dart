import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_option_response.freezed.dart';
part 'order_option_response.g.dart';

@freezed
abstract class CommodityResponse with _$CommodityResponse {
  const factory CommodityResponse({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "name") String? name,
  }) = _CommodityResponse;

  factory CommodityResponse.fromJson(Map<String, dynamic> json) =>
      _$CommodityResponseFromJson(json);
}

@freezed
abstract class HandlingResponse with _$HandlingResponse {
  const factory HandlingResponse({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "name") String? name,
  }) = _HandlingResponse;

  factory HandlingResponse.fromJson(Map<String, dynamic> json) =>
      _$HandlingResponseFromJson(json);
}
