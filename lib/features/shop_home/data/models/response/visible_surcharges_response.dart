import 'package:freezed_annotation/freezed_annotation.dart';

part 'visible_surcharges_response.freezed.dart';
part 'visible_surcharges_response.g.dart';

@freezed
abstract class VisibleSurchargesResponse with _$VisibleSurchargesResponse {
  const factory VisibleSurchargesResponse({
    @JsonKey(name: "data") @Default([]) List<SurchargeGroupResponse> data,
  }) = _VisibleSurchargesResponse;

  factory VisibleSurchargesResponse.fromJson(Map<String, dynamic> json) =>
      _$VisibleSurchargesResponseFromJson(json);
}

@freezed
abstract class SurchargeGroupResponse with _$SurchargeGroupResponse {
  const factory SurchargeGroupResponse({
    @JsonKey(name: "group") String? group,
    @JsonKey(name: "groupName") String? groupName,
    @JsonKey(name: "surcharges")
    @Default([])
    List<SurchargeResponse> surcharges,
  }) = _SurchargeGroupResponse;

  factory SurchargeGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$SurchargeGroupResponseFromJson(json);
}

@freezed
abstract class SurchargeResponse with _$SurchargeResponse {
  const factory SurchargeResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "label") String? label,
    @JsonKey(name: "feeType") String? feeType,
    @JsonKey(name: "sortOrder") int? sortOrder,
    @JsonKey(name: "group") String? group,
    @JsonKey(name: "isEnabled") bool? isEnabled,
    @JsonKey(name: "fee") int? fee,
    @JsonKey(name: "feePercent") int? feePercent,
    @JsonKey(name: "customNote") String? customNote,
    @JsonKey(name: "isVisibleOnShop") bool? isVisibleOnShop,
    @JsonKey(name: "tiers") @Default([]) List<SurchargeTierResponse> tiers,
  }) = _SurchargeResponse;

  factory SurchargeResponse.fromJson(Map<String, dynamic> json) =>
      _$SurchargeResponseFromJson(json);
}

@freezed
abstract class SurchargeTierResponse with _$SurchargeTierResponse {
  const factory SurchargeTierResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "tierLabel") String? tierLabel,
    @JsonKey(name: "fee") num? fee,
    @JsonKey(name: "feeType") String? feeType,
    @JsonKey(name: "sortOrder") int? sortOrder,
    @JsonKey(name: "fromValue") int? fromValue,
    @JsonKey(name: "toValue") int? toValue,
  }) = _SurchargeTierResponse;

  factory SurchargeTierResponse.fromJson(Map<String, dynamic> json) =>
      _$SurchargeTierResponseFromJson(json);
}
