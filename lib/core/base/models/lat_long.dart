import 'package:freezed_annotation/freezed_annotation.dart';

part 'lat_long.freezed.dart';
part 'lat_long.g.dart';

@freezed
abstract class LatLong with _$LatLong {
  const factory LatLong({
    @JsonKey(name: "lat") double? lat,
    @JsonKey(name: "long") double? long,
  }) = _LatLong;

  factory LatLong.fromJson(Map<String, dynamic> json) =>
      _$LatLongFromJson(json);
}
