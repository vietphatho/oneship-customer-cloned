import 'package:flutter_map/flutter_map.dart';
// import 'package:maplibre/maplibre.dart';

abstract class MapEvent {
  const MapEvent();
}

class MapSetController extends MapEvent {
  final MapController mapController;

  MapSetController(this.mapController);
}
