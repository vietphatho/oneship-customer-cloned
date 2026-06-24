import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/map_libre/presentation/views/primary_map_view.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LocationServiceBloc _locationServiceBloc = getIt.get();
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceBloc, LocationServiceState>(
      bloc: _locationServiceBloc,
      buildWhen: (_, state) => state is GetCurrentLocationState,
      builder: (context, state) {
        LatLng curCoor = LatLng(0, 0);

        if (state is GetCurrentLocationState) {
          curCoor = LatLng(
            state.resource.data?.latitude ?? 0,
            state.resource.data?.longitude ?? 0,
          );
        }

        return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
          bloc: _orderTrackingBloc,
          builder: (context, ordTrackingState) {
            LatLng shopCoor =
                ordTrackingState
                    .trackingResult
                    .data
                    ?.shopInfo
                    ?.coordinate
                    ?.latLng ??
                LatLng(0, 0);

            return SizedBox(
              height: 200,
              child: PrimaryMapView(
                currentLocation: curCoor,
                shopLocation: shopCoor,
              ),
            );
          },
        );
      },
    );
  }
}
