abstract class PackagesEvent {
  const PackagesEvent();
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
