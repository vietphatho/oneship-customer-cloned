import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';

abstract class LocationServiceEvent {
  const LocationServiceEvent();
}

class LocationServiceInitEvent extends LocationServiceEvent {
  const LocationServiceInitEvent();
}

class LocationServiceSearchProvincesEvent extends LocationServiceEvent {
  final String keyword;

  LocationServiceSearchProvincesEvent(this.keyword);
}

class LocationServiceSearchWardsEvent extends LocationServiceEvent {
  final Province province;
  final String keyword;

  LocationServiceSearchWardsEvent({required this.province, this.keyword = ""});
}

class LocationServiceSearchAddressEvent extends LocationServiceEvent {
  final Province province;
  final Ward ward;
  final String address;

  LocationServiceSearchAddressEvent({
    required this.province,
    required this.ward,
    this.address = "",
  });
}
