// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:maplibre/maplibre.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

class PrimaryMapView extends StatelessWidget {
  const PrimaryMapView({
    super.key,
    this.currentLocation,
    this.shopLocation,
    this.mapCtrl,
    // this.onMapCreated,
  });

  final LatLng? currentLocation;
  final LatLng? shopLocation;
  final MapController? mapCtrl;
  // final void Function(MapController)? onMapCreated;

  @override
  Widget build(BuildContext context) {
    // return MapLibreMap(
    //   options: MapOptions(
    //     initStyle: 'https://demotiles.maplibre.org/style.json',
    //     // initCenter: Geographic(lon: 106.7009, lat: 10.7769),
    //     initZoom: 14,
    //   ),
    //   onMapCreated: onMapCreated,
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
          userAgentPackageName: "com.onexway.oneship.cus",
        ),
        MarkerLayer(
          markers: [
            if (currentLocation != null)
              Marker(
                point: currentLocation!,
                width: 64,
                height: 64,
                child: Icon(Icons.location_pin, color: AppColors.expenseRed),
              ),
            if (shopLocation != null)
              Marker(
                point: shopLocation!,
                width: 64,
                height: 64,
                child: Icon(Icons.store_rounded, color: AppColors.accentColor1),
              ),
          ],
        ),
      ],
    );
  }
}
