import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipper_info_response.freezed.dart';
part 'shipper_info_response.g.dart';

@freezed
abstract class ShipperInfoResponse with _$ShipperInfoResponse {
  const factory ShipperInfoResponse({
    @JsonKey(name: "shipperCode") String? shipperCode,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "rating") int? rating,
    @JsonKey(name: "avatarUrl") String? avatarUrl,
  }) = _ShipperInfoResponse;

  factory ShipperInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ShipperInfoResponseFromJson(json);
}
