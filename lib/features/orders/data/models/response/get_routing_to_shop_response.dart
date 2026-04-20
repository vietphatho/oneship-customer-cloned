import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_routing_to_shop_response.freezed.dart';
part 'get_routing_to_shop_response.g.dart';

@freezed
abstract class GetRoutingToShopResponse with _$GetRoutingToShopResponse {
  const factory GetRoutingToShopResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "orderCoordinates") List<double>? orderCoordinates,
    @JsonKey(name: "fullRouteData") FullRouteData? fullRouteData,
  }) = _GetRoutingToShopResponse;

  factory GetRoutingToShopResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRoutingToShopResponseFromJson(json);
}

@freezed
abstract class FullRouteData with _$FullRouteData {
  const factory FullRouteData({
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "weight") double? weight,
    @JsonKey(name: "time") int? time,
    @JsonKey(name: "transfers") int? transfers,
    @JsonKey(name: "points_encoded") bool? pointsEncoded,
    @JsonKey(name: "bbox") List<double>? bbox,
    @JsonKey(name: "snapped_waypoints") Points? snappedWaypoints,
    @JsonKey(name: "points") Points? points,
    @JsonKey(name: "instructions") List<Instruction>? instructions,
    @JsonKey(name: "orderCoordinates") List<double>? orderCoordinates,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "ward") String? ward,
    @JsonKey(name: "city") String? city,
  }) = _FullRouteData;

  factory FullRouteData.fromJson(Map<String, dynamic> json) =>
      _$FullRouteDataFromJson(json);
}

@freezed
abstract class Instruction with _$Instruction {
  const factory Instruction({
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "heading") double? heading,
    @JsonKey(name: "sign") int? sign,
    @JsonKey(name: "interval") List<int>? interval,
    @JsonKey(name: "text") String? text,
    @JsonKey(name: "time") int? time,
    @JsonKey(name: "street_name") String? streetName,
    @JsonKey(name: "last_heading") double? lastHeading,
  }) = _Instruction;

  factory Instruction.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);
}

@freezed
abstract class Points with _$Points {
  const factory Points({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "coordinates") List<List<double>>? coordinates,
  }) = _Points;

  factory Points.fromJson(Map<String, dynamic> json) => _$PointsFromJson(json);
}
