import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';

part 'packages_state.freezed.dart';

@freezed
abstract class PackagesState with _$PackagesState {
  const factory PackagesState({
    required Resource<List<Package>> pkgsData,
    required Resource<PackageDetail> currentPkg,
    required Resource findingShipperResult,
    required Resource cancelFindingShipperResult,
  }) = _PackagesState;
}
