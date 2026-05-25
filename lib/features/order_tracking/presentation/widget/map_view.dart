import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/map/presentation/views/primary_map_view.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationServiceBloc _locationServiceBloc = getIt.get();
  ShopBloc _shopBloc = getIt.get();
  final MapController _mapCtrl = MapController();

  @override
  Widget build(BuildContext context) {
    var shopCoor = _shopBloc.state.currentShop?.shopCoordinates?.latLng;

    return BlocListener(
      bloc: _locationServiceBloc,
      listener: _listenGetLocationChanged,
      child: BlocSelector<LocationServiceBloc, LocationServiceState, Position?>(
        bloc: _locationServiceBloc,
        selector:
            (state) =>
                state is GetCurrentLocationState ? state.resource.data : null,
        builder: (context, curPos) {
          LatLng curCoor = LatLng(
            curPos?.latitude ?? 0,
            curPos?.longitude ?? 0,
          );

          return SizedBox(
            height: 300,
            child: PrimaryMapView(
              mapCtrl: _mapCtrl,
              currentLocation: curCoor,
              shopLocation: shopCoor,
            ),
          );
        },
      ),
    );
  }

  void _listenGetLocationChanged(
    BuildContext context,
    LocationServiceState state,
  ) async {
    if (state is GetCurrentLocationState) {
      if (state.resource.data != null) {
        LatLng curCoor = LatLng(
          state.resource.data!.latitude,
          state.resource.data!.longitude,
        );
        LatLng? shopCoor = _shopBloc.state.currentShop?.shopCoordinates?.latLng;

        await Future.delayed(Durations.medium4);
        // _mapCtrl.fitCamera(
        //   CameraFit.coordinates(coordinates: [curCoor, shopCoor ?? curCoor]),
        // );
        _mapCtrl.move(curCoor, 16.5);
      }
    }
  }
}
