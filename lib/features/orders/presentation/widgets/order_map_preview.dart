import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as map_latlong;
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/map_libre/presentation/views/primary_map_view.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class CreateOrderMapPreview extends StatelessWidget {
  CreateOrderMapPreview({super.key});

  final CreateOrderBloc _createOrderBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        return OrderMapPreview(
          shopLocation: state.shopInfo.shopCoordinates?.latLong,
          deliveryLocation: _toLatLong(_deliveryCoordinates(state)),
        );
      },
    );
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
    this.height = 220,
  });

  final LatLong? shopLocation;
  final LatLong? deliveryLocation;
  final double height;

  @override
  Widget build(BuildContext context) {
    final shopLatLng = _toMapLatLng(shopLocation);
    final deliveryLatLng = _toMapLatLng(deliveryLocation);
    if (shopLatLng == null || deliveryLatLng == null) {
      return const SizedBox.shrink();
    }

    return PrimaryFrame(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppDimensions.mediumBorderRadius,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: PrimaryMapView(
            currentLocation: deliveryLatLng,
            shopLocation: shopLatLng,
          ),
        ),
      ),
    );
  }

  map_latlong.LatLng? _toMapLatLng(LatLong? coordinate) {
    final lat = coordinate?.lat;
    final long = coordinate?.long;
    if (lat == null || long == null) return null;
    return map_latlong.LatLng(lat, long);
  }
}
