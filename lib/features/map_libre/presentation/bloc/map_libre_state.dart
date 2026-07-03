import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maplibre/maplibre.dart';

part 'map_libre_state.freezed.dart';

@freezed
abstract class MapLibreState with _$MapLibreState {
  const factory MapLibreState({
    MapController? mapCtrl,
    @Default([]) List<Feature<Point>> customerMarker,
    @Default([]) List<Feature<Point>> shopMarker,
    @Default([]) List<Feature<LineString>> routePolylines,
  }) = _MapLibreState;
}
