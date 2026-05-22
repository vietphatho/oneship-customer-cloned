import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryMapView extends StatelessWidget {
  const PrimaryMapView({
    super.key,
    this.currentLocation,
    this.shopLocation,
    this.mapCtrl,
  });

  final LatLng? currentLocation;
  final LatLng? shopLocation;
  final MapController? mapCtrl;

  @override
  Widget build(BuildContext context) {
    // return MapLibreMap(
    //   options: MapOptions(
    //     initStyle: 'https://demotiles.maplibre.org/style.json',
    //     initCenter: Position(106.7009, 10.7769),
    //     initZoom: 14,
    //   ),
    // );
    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        initialCenter: LatLng(10.7769, 106.7009),
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: "com.onexway.oneship.customer",
        ),
        MarkerLayer(
          markers: [
            if (currentLocation != null)
              Marker(
                point: currentLocation!,
                width: 56,
                height: 56,
                child: Icon(Icons.location_pin, color: AppColors.expenseRed),
              ),
            if (shopLocation != null)
              Marker(
                point: shopLocation!,
                width: 56,
                height: 56,
                child: Icon(Icons.store_rounded, color: AppColors.accentColor1),
              ),
          ],
        ),
      ],
    );
  }
}
