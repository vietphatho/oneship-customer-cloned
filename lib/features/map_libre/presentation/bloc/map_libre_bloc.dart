import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:maplibre/maplibre.dart';
import 'package:oneship_customer/features/map_libre/enum.dart';
import 'package:oneship_customer/features/map_libre/presentation/bloc/map_libre_event.dart';
import 'package:oneship_customer/features/map_libre/presentation/bloc/map_libre_state.dart';

@lazySingleton
class MapLibreBloc extends Bloc<MapLibreEvent, MapLibreState> {
  MapLibreBloc() : super(const MapLibreState()) {
    on<MapSetController>(_onSetController);
    on<MapStyleReady>(_onStyleReady);
    on<MapAddMarker>(_onAddMarker);
    on<MapSyncLocations>(_onSyncLocations);
  }

  MapSyncLocations? _pendingLocations;
  List<Geographic> _cameraCoordinates = const [];
  String? _lastFitCameraSignature;
  bool _isStyleReady = false;

  Future<void> _onSetController(
    MapSetController event,
    Emitter<MapLibreState> emit,
  ) async {
    emit(state.copyWith(mapCtrl: event.mapController));
    _lastFitCameraSignature = null;
    await _fitCameraIfReady(_cameraCoordinates);
  }

  Future<void> _onStyleReady(
    MapStyleReady event,
    Emitter<MapLibreState> emit,
  ) async {
    _isStyleReady = true;
    _lastFitCameraSignature = null;
    await _syncPendingLocations(emit);
  }

  FutureOr<void> _onAddMarker(MapAddMarker event, Emitter<MapLibreState> emit) {
    if (event.type == MarkerType.customer) {
      emit(state.copyWith(customerMarker: [event.marker]));
    } else if (event.type == MarkerType.shop) {
      emit(state.copyWith(shopMarker: [event.marker]));
    }
  }

  Future<void> _onSyncLocations(
    MapSyncLocations event,
    Emitter<MapLibreState> emit,
  ) async {
    _pendingLocations = event;
    await _syncPendingLocations(emit);
  }

  Future<void> _syncPendingLocations(Emitter<MapLibreState> emit) async {
    final event = _pendingLocations;
    if (event == null) return;

    final customerMarkers = <Feature<Point>>[];
    final shopMarkers = <Feature<Point>>[];
    final routePolylines = <Feature<LineString>>[];

    if (event.showCurrentLocation && event.currentLocation != null) {
      customerMarkers.add(Feature(geometry: Point(event.currentLocation!)));
    }

    if (event.shopLocation != null) {
      shopMarkers.add(Feature(geometry: Point(event.shopLocation!)));
    }

    if (event.routeCoordinates.length > 1) {
      routePolylines.add(
        Feature(
          geometry: LineString(PositionSeries.from(event.routeCoordinates)),
        ),
      );
    }

    final cameraCoordinates = <Geographic>[
      if (event.routeCoordinates.length > 1) ...event.routeCoordinates,
      if (event.shopLocation != null) event.shopLocation!,
      if (event.showCurrentLocation && event.currentLocation != null)
        event.currentLocation!,
    ];

    _cameraCoordinates = cameraCoordinates;
    if (!_isStyleReady) return;

    emit(
      state.copyWith(
        customerMarker: customerMarkers,
        shopMarker: shopMarkers,
        routePolylines: routePolylines,
      ),
    );

    await _fitCameraIfReady(cameraCoordinates);
  }

  void setMapController(MapController mapController) {
    add(MapSetController(mapController));
  }

  void setStyleReady() {
    add(MapStyleReady());
  }

  void addMarker({required Feature<Point> marker, required MarkerType type}) {
    add(MapAddMarker(type: type, marker: marker));
  }

  void syncLocations({
    required Geographic? currentLocation,
    required Geographic? shopLocation,
    required bool showCurrentLocation,
    List<Geographic> routeCoordinates = const [],
  }) {
    add(
      MapSyncLocations(
        currentLocation: currentLocation,
        shopLocation: shopLocation,
        showCurrentLocation: showCurrentLocation,
        routeCoordinates: routeCoordinates,
      ),
    );
  }

  void fitCamera(List<Geographic> coordinates) async {
    await _fitCameraIfReady(coordinates);
  }

  Future<void> _fitCameraIfReady(List<Geographic> coordinates) async {
    if (!_isStyleReady) return;
    await _fitCameraIfNeeded(coordinates);
  }

  Future<void> _fitCameraIfNeeded(List<Geographic> coordinates) async {
    if (state.mapCtrl == null || coordinates.isEmpty) return;

    final signature = _cameraSignature(coordinates);
    if (_lastFitCameraSignature == signature) return;

    _lastFitCameraSignature = signature;

    if (coordinates.length == 1) {
      await state.mapCtrl?.animateCamera(center: coordinates.first);
    } else {
      await state.mapCtrl?.fitBounds(
        bounds: LngLatBounds.fromPoints(coordinates),
        padding: const EdgeInsets.all(40),
      );
    }
  }

  String _cameraSignature(List<Geographic> coordinates) {
    return coordinates.map((item) => "${item.lat},${item.lon}").join("|");
  }
}
