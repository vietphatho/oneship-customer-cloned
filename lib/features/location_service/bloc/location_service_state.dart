import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';

abstract class LocationServiceState {
  // All data
  final List<Province> provinces;
  final Map<String, List<Ward>> wardsByProvince;

  const LocationServiceState({
    this.provinces = const [],
    this.wardsByProvince = const {},
  });
}

class LocationServiceProvincesChangedState extends LocationServiceState {
  final List<Province> filteredProvinces;

  LocationServiceProvincesChangedState({
    super.provinces,
    super.wardsByProvince,
    required this.filteredProvinces,
  });
}

class LocationServiceWardsChangedState extends LocationServiceState {
  final List<Ward> filteredWards;

  LocationServiceWardsChangedState({
    super.provinces,
    super.wardsByProvince,
    required this.filteredWards,
  });
}

class LocationServiceSearchAddressState extends LocationServiceState {
  final Resource<List<SuggestedAddressResponse>> suggestedAdds;

  LocationServiceSearchAddressState(this.suggestedAdds);
}
