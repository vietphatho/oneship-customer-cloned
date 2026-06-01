import 'package:oneship_customer/features/packages/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

abstract class PackagesEvent {
  const PackagesEvent();
}

class PackageInitEvent extends PackagesEvent {
  final BriefShopEntity shop;

  PackageInitEvent(this.shop);
}

class PackagesFetchingEvent extends PackagesEvent {
  const PackagesFetchingEvent();
}

class PackagesFilterResultsEvent extends PackagesEvent {
  final String? packageNumber;
  final String? shipperCode;
  final PackageStatus? status;

  const PackagesFilterResultsEvent({
    this.packageNumber,
    this.shipperCode,
    this.status,
  });
}

class PackagesLoadMoreEvent extends PackagesEvent {
  const PackagesLoadMoreEvent();
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

class PackagesFindingShipperStatusEvent extends PackagesEvent {
  final bool status;
  const PackagesFindingShipperStatusEvent(this.status);
}
