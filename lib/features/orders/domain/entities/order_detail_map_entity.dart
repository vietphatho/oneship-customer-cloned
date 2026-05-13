import 'package:oneship_customer/core/base/models/lat_long.dart';

class OrderDetailMapEntity {
  const OrderDetailMapEntity({
    this.shopLatLong,
    this.deliveryLatLong,
    this.shopAddress,
    this.deliveryAddress,
  });

  final LatLong? shopLatLong;
  final LatLong? deliveryLatLong;
  final String? shopAddress;
  final String? deliveryAddress;

  bool get hasAnyCoordinates =>
      (shopLatLong?.lat != null && shopLatLong?.long != null) ||
      (deliveryLatLong?.lat != null && deliveryLatLong?.long != null);
}
