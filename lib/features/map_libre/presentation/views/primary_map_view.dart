import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:maplibre/maplibre.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/features/map_libre/enum.dart';
import 'package:oneship_customer/features/map_libre/presentation/bloc/map_libre_bloc.dart';
import 'package:oneship_customer/features/map_libre/presentation/bloc/map_libre_state.dart';

class PrimaryMapView extends StatefulWidget {
  const PrimaryMapView({
    super.key,
    required this.currentLocation,
    required this.shopLocation,
    this.showCurrentLocation = true,
    this.routeCoordinates = const [],
  });

  final LatLng currentLocation;
  final LatLng shopLocation;
  final bool showCurrentLocation;
  final List<LatLng> routeCoordinates;

  @override
  State<PrimaryMapView> createState() => _PrimaryMapViewState();
}

class _PrimaryMapViewState extends State<PrimaryMapView> {
  final MapLibreBloc _mapLibreBloc = MapLibreBloc();

  @override
  void initState() {
    super.initState();
    _syncMapLocations();
  }

  @override
  void didUpdateWidget(covariant PrimaryMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocation != widget.currentLocation ||
        oldWidget.shopLocation != widget.shopLocation ||
        oldWidget.showCurrentLocation != widget.showCurrentLocation ||
        !const ListEquality<LatLng>().equals(
          oldWidget.routeCoordinates,
          widget.routeCoordinates,
        )) {
      _syncMapLocations();
    }
  }

  @override
  void dispose() {
    _mapLibreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = _toGeographic(widget.currentLocation);
    final shopLocation = _toGeographic(widget.shopLocation);
    final initialCenter =
        currentLocation ?? shopLocation ?? const Geographic(lon: 0, lat: 0);

    return BlocBuilder<MapLibreBloc, MapLibreState>(
      bloc: _mapLibreBloc,
      builder: (context, state) {
        return MapLibreMap(
          options: MapOptions(
            initStyle: jsonEncode(Constants.googleMapsStyleJson),
            initCenter: initialCenter,
            initZoom: Constants.defaultZoom,
          ),
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onEvent: (event) async {
            switch (event) {
              case MapEventMapCreated():
                _mapLibreBloc.setMapController(event.mapController);

                if (Platform.isIOS) {
                  event.mapController.setStyle(
                    jsonEncode(Constants.googleMapsStyleJson),
                  );
                }
              case MapEventStyleLoaded():
                await event.style.addImageFromAssets(
                  id: MarkerType.customer.value,
                  asset: ImagePath.iconCusLocation,
                );

                await event.style.addImageFromAssets(
                  id: MarkerType.shop.value,
                  asset: ImagePath.iconShopLocation,
                );

                _mapLibreBloc.setStyleReady();

              case MapEventClick():
                // add a new marker on click
                break;
              default:
                // ignore all other events
                break;
            }
          },
          layers: [
            if (state.routePolylines.isNotEmpty)
              PolylineLayer(
                polylines: state.routePolylines,
                color: AppColors.blue600,
                width: 5,
              ),

            if (state.customerMarker.isNotEmpty)
              MarkerLayer(
                points: state.customerMarker,
                textField: '{name}',
                textAllowOverlap: true,
                iconImage: MarkerType.customer.value,
                iconSize: 0.9,
                iconAnchor: IconAnchor.bottom,
                textOffset: const [0, 1],
              ),

            if (state.shopMarker.isNotEmpty)
              MarkerLayer(
                points: state.shopMarker,
                textField: '{name}',
                textAllowOverlap: true,
                iconImage: MarkerType.shop.value,
                iconSize: 0.9,
                iconAnchor: IconAnchor.bottom,
                textOffset: const [0, 1],
              ),
          ],
          children: [
            Transform.scale(
              scale: 0.58,
              alignment: Alignment.bottomRight,
              child: SourceAttribution(
                showMapLibre: false,
                padding: AppDimensions.xSmallPaddingAll,
              ),
            ),
          ],
        );
      },
    );
  }

  void _syncMapLocations() {
    _mapLibreBloc.syncLocations(
      currentLocation: _toGeographic(widget.currentLocation),
      shopLocation: _toGeographic(widget.shopLocation),
      showCurrentLocation: widget.showCurrentLocation,
      routeCoordinates: widget.routeCoordinates
          .map(_toGeographic)
          .whereType<Geographic>()
          .toList(),
    );
  }

  Geographic? _toGeographic(LatLng coordinate) {
    if (coordinate.latitude == 0 && coordinate.longitude == 0) return null;

    return Geographic(lon: coordinate.longitude, lat: coordinate.latitude);
  }
}
