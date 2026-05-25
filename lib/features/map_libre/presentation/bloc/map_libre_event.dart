import 'package:maplibre/maplibre.dart';
import 'package:oneship_customer/features/map_libre/enum.dart';

abstract class MapLibreEvent {
  const MapLibreEvent();
}

class MapSetController extends MapLibreEvent {
  final MapController mapController;

  MapSetController(this.mapController);
}

class MapAddMarker extends MapLibreEvent {
  final Feature<Point> marker;
  final MarkerType type;

  MapAddMarker({required this.marker, required this.type});
}
