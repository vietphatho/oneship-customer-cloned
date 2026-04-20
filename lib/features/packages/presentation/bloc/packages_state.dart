import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';

abstract class PackagesState {
  const PackagesState({required this.pkgsData, required this.currentPkg});

  final Resource<List<Package>> pkgsData;
  final Resource<PackageDetail> currentPkg;
}

class PackagesFetchedState extends PackagesState {
  PackagesFetchedState({required super.currentPkg, required super.pkgsData});
}

class PackagesViewDetailState extends PackagesState {
  PackagesViewDetailState({required super.pkgsData, required super.currentPkg});
}

class PackagesFindShipperState extends PackagesState {
  final Resource resource;

  PackagesFindShipperState({
    required super.pkgsData,
    required super.currentPkg,
    required this.resource,
  });
}

class PackagesCancelFindingShipperState extends PackagesState {
  final Resource resource;

  PackagesCancelFindingShipperState({
    required super.pkgsData,
    required super.currentPkg,
    required this.resource,
  });
}
