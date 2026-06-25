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
    on<MapAddMarker>(_onAddMarker);
    on<MapSyncLocations>(_onSyncLocations);
  }

  List<Geographic> _cameraCoordinates = const [];
  String? _lastFitCameraSignature;

  Future<void> _onSetController(
    MapSetController event,
    Emitter<MapLibreState> emit,
  ) async {
    emit(state.copyWith(mapCtrl: event.mapController));
    _lastFitCameraSignature = null;
    await _fitCameraIfNeeded(event.mapController, _cameraCoordinates);
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
    final customerMarkers = <Feature<Point>>[];
    final shopMarkers = <Feature<Point>>[];
    final cameraCoordinates = <Geographic>[];

    if (event.showCurrentLocation && event.currentLocation != null) {
      customerMarkers.add(Feature(geometry: Point(event.currentLocation!)));
      cameraCoordinates.add(event.currentLocation!);
    }

    if (event.shopLocation != null) {
      shopMarkers.add(Feature(geometry: Point(event.shopLocation!)));
      cameraCoordinates.add(event.shopLocation!);
    }

    _cameraCoordinates = cameraCoordinates;
    emit(
      state.copyWith(customerMarker: customerMarkers, shopMarker: shopMarkers),
    );

    await _fitCameraIfNeeded(state.mapCtrl, cameraCoordinates);
  }

  void setMapController(MapController mapController) {
    add(MapSetController(mapController));
  }

  void addMarker({required Feature<Point> marker, required MarkerType type}) {
    add(MapAddMarker(type: type, marker: marker));
  }

  void syncLocations({
    required Geographic? currentLocation,
    required Geographic? shopLocation,
    required bool showCurrentLocation,
  }) {
    add(
      MapSyncLocations(
        currentLocation: currentLocation,
        shopLocation: shopLocation,
        showCurrentLocation: showCurrentLocation,
      ),
    );
  }

  void fitCamera(List<Geographic> coordinates) async {
    await _fitCameraIfNeeded(state.mapCtrl, coordinates);
  }

  Future<void> _fitCameraIfNeeded(
    MapController? mapCtrl,
    List<Geographic> coordinates,
  ) async {
    if (mapCtrl == null || coordinates.isEmpty) return;

    final signature = _cameraSignature(coordinates);
    if (_lastFitCameraSignature == signature) return;

    _lastFitCameraSignature = signature;
    await mapCtrl.fitBounds(
      bounds: LngLatBounds.fromPoints(coordinates),
      padding: const EdgeInsets.all(40),
    );
  }

  String _cameraSignature(List<Geographic> coordinates) {
    return coordinates.map((item) => "${item.lat},${item.lon}").join("|");
  }
}
