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
  }

  FutureOr<void> _onSetController(
    MapSetController event,
    Emitter<MapLibreState> emit,
  ) {
    emit(state.copyWith(mapCtrl: event.mapController));
  }

  FutureOr<void> _onAddMarker(MapAddMarker event, Emitter<MapLibreState> emit) {
    if (event.type == MarkerType.customer) {
      final cusMarkers = List<Feature<Point>>.from(state.customerMarker);
      cusMarkers.add(event.marker);
      emit(state.copyWith(customerMarker: cusMarkers));
    } else if (event.type == MarkerType.shop) {
      final shopMarkers = List<Feature<Point>>.from(state.shopMarker);
      shopMarkers.add(event.marker);
      emit(state.copyWith(shopMarker: shopMarkers));
    }
  }

  void setMapController(MapController mapController) {
    add(MapSetController(mapController));
  }

  void addMarker({required Feature<Point> marker, required MarkerType type}) {
    add(MapAddMarker(type: type, marker: marker));
  }

  void fitCamera(List<Geographic> coordinates) async {
    await state.mapCtrl?.fitBounds(
      bounds: LngLatBounds.fromPoints(coordinates),
      padding: EdgeInsets.all(200),
    );
  }
}
