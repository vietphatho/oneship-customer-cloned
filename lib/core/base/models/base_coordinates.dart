import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';

part 'base_coordinates.freezed.dart';
part 'base_coordinates.g.dart';

@freezed
abstract class BaseCoordinates with _$BaseCoordinates {
  const factory BaseCoordinates({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "coordinates") List<double>? coordinates,
  }) = _BaseCoordinates;

  factory BaseCoordinates.fromJson(Map<String, dynamic> json) =>
      _$BaseCoordinatesFromJson(json);

  // factory BaseCoordinates.fromCoor() =>
}

extension BaseCoordinatesExt on BaseCoordinates {
  LatLong get latLong =>
      LatLong(lat: coordinates?.lastOrNull, long: coordinates?.firstOrNull);
}
