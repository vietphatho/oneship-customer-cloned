import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

abstract class PackagesEvent {
  const PackagesEvent();
}

class PackageInitEvent extends PackagesEvent {
  final ShopEntity shop;

  PackageInitEvent(this.shop);
}

class PackagesFetchingEvent extends PackagesEvent {
  const PackagesFetchingEvent();
}

class PackagesViewDetailEvent extends PackagesEvent {
  final String pkgId;

  PackagesViewDetailEvent(this.pkgId);
}

class PackagesFindShipperEvent extends PackagesEvent {
  const PackagesFindShipperEvent();
}

class PackagesCancelFindingShipperEvent extends PackagesEvent {
  const PackagesCancelFindingShipperEvent();
}
