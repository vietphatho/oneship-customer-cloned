import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';

abstract class PackagesRepository extends BaseRepository {
  Future<Resource<PackagesListResponse>> fetchPackages({
    required String shopId,
  });

  Future<Resource<PackageDetail>> fetchPackageDetail({
    required String shopId,
    required String pkgId,
  });

  Future<Resource> findShipper(String shopId);

  Future<Resource> cancelFindingShipper(String shopId);
}
