import 'dart:convert';

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
  });

  final LatLng currentLocation;
  final LatLng shopLocation;

  @override
  State<PrimaryMapView> createState() => _PrimaryMapViewState();
}

class _PrimaryMapViewState extends State<PrimaryMapView> {
  final MapLibreBloc _mapLibreBloc = MapLibreBloc();

  @override
  void dispose() {
    _mapLibreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Geographic currentLocation = Geographic(
      lon: widget.currentLocation.longitude,
      lat: widget.currentLocation.latitude,
    );
    final Geographic shopLocation = Geographic(
      lon: widget.shopLocation.longitude,
      lat: widget.shopLocation.latitude,
    );

    return BlocBuilder<MapLibreBloc, MapLibreState>(
      bloc: _mapLibreBloc,
      builder: (context, state) {
        return MapLibreMap(
          options: MapOptions(
            initStyle: jsonEncode(Constants.googleMapsStyleJson),
            initCenter: currentLocation,
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
              case MapEventStyleLoaded():
                // add marker image to map
                await event.style.addImageFromAssets(
                  id: MarkerType.customer.value,
                  asset: ImagePath.iconCusLocation,
                );

                await event.style.addImageFromAssets(
                  id: MarkerType.shop.value,
                  asset: ImagePath.iconShopLocation,
                );

                _mapLibreBloc.addMarker(
                  marker: Feature(geometry: Point(currentLocation)),
                  type: MarkerType.customer,
                );

                _mapLibreBloc.addMarker(
                  marker: Feature(geometry: Point(shopLocation)),
                  type: MarkerType.shop,
                );

                _mapLibreBloc.fitCamera([currentLocation, shopLocation]);

              case MapEventClick():
                // add a new marker on click
                break;
              default:
                // ignore all other events
                break;
            }
          },
          layers: [
            MarkerLayer(
              points: state.customerMarker,
              textField: '{name}',
              textAllowOverlap: true,
              iconImage: MarkerType.customer.value,
              iconSize: 0.075,
              iconAnchor: IconAnchor.bottom,
              textOffset: const [0, 1],
            ),

            MarkerLayer(
              points: state.shopMarker,
              textField: '{name}',
              textAllowOverlap: true,
              iconImage: MarkerType.shop.value,
              iconSize: 0.075,
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
}
