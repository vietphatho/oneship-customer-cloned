import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as map_latlong;
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/map_libre/presentation/views/primary_map_view.dart';
import 'package:oneship_customer/features/orders/domain/entities/routing_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class CreateOrderMapPreview extends StatelessWidget {
  CreateOrderMapPreview({super.key, this.height = 220});

  final CreateOrderBloc _createOrderBloc = getIt.get();
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        return OrderMapPreview(
          shopLocation: state.shopInfo.shopCoordinates?.latLong,
          deliveryLocation: _toLatLong(_deliveryCoordinates(state)),
          routeCoordinates: _routing(state)?.routeCoordinates ?? const [],
          height: height,
        );
      },
    );
  }

  RoutingEntity? _routing(CreateOrderState state) {
    final requestRouter = state.request.router;
    if (_hasRoutingData(requestRouter)) return requestRouter;

    final draftRouter = state.draftRequest.router;
    if (_hasRoutingData(draftRouter)) return draftRouter;

    final response = state.routingToShopResource.data;
    return response != null ? RoutingEntity.from(response) : null;
  }

  bool _hasRoutingData(RoutingEntity? routing) {
    return routing != null &&
        (routing.orderCoordinates.isNotEmpty ||
            routing.routeCoordinates.isNotEmpty);
  }

  List<double>? _deliveryCoordinates(CreateOrderState state) {
    if (state.request.router?.orderCoordinates.isNotEmpty == true) {
      return state.request.router?.orderCoordinates;
    }
    if (state.draftRequest.router?.orderCoordinates.isNotEmpty == true) {
      return state.draftRequest.router?.orderCoordinates;
    }
    return state.routingToShopResource.data?.orderCoordinates;
  }

  LatLong? _toLatLong(List<double>? coordinates) {
    if ((coordinates?.length ?? 0) < 2) return null;
    return LatLong(lat: coordinates![1], long: coordinates[0]);
  }
}

class OrderMapPreview extends StatelessWidget {
  const OrderMapPreview({
    super.key,
    required this.shopLocation,
    required this.deliveryLocation,
    this.routeCoordinates = const [],
    this.height = 220,
  });

  final LatLong? shopLocation;
  final LatLong? deliveryLocation;
  final List<List<double>> routeCoordinates;
  final double height;

  @override
  Widget build(BuildContext context) {
    final shopLatLng = _toMapLatLng(shopLocation);
    final deliveryLatLng = _toMapLatLng(deliveryLocation);
    if (shopLatLng == null) {
      return const SizedBox.shrink();
    }
    final initialLocation = deliveryLatLng ?? shopLatLng;

    return PrimaryFrame(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppDimensions.largeBorderRadius,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: PrimaryMapView(
            currentLocation: initialLocation,
            shopLocation: shopLatLng,
            showCurrentLocation: deliveryLatLng != null,
            routeCoordinates: _toRouteLatLng(routeCoordinates),
          ),
        ),
      ),
    );
  }

  List<map_latlong.LatLng> _toRouteLatLng(List<List<double>> coordinates) {
    return coordinates
        .where((coordinate) => coordinate.length >= 2)
        .map((coordinate) => map_latlong.LatLng(coordinate[1], coordinate[0]))
        .toList();
  }

  map_latlong.LatLng? _toMapLatLng(LatLong? coordinate) {
    final lat = coordinate?.lat;
    final long = coordinate?.long;
    if (lat == null || long == null) return null;
    return map_latlong.LatLng(lat, long);
  }
}
