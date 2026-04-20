import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/datasources/packages_api.dart';
import 'package:oneship_customer/features/packages/data/enum.dart';
import 'package:oneship_customer/features/packages/data/models/request/package_dispatch_request.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:oneship_customer/features/packages/domain/repositories/packages_repository.dart';

@LazySingleton(as: PackagesRepository)
class PackagesRepositoryImpl extends PackagesRepository {
  final PackagesApi _packagesApi;

  PackagesRepositoryImpl(this._packagesApi);

  @override
  Future<Resource<PackagesListResponse>> fetchPackages({
    required String shopId,
  }) {
    return request(() => _packagesApi.fetchPackages(shopId: shopId));
  }

  @override
  Future<Resource<PackageDetail>> fetchPackageDetail({
    required String shopId,
    required String pkgId,
  }) {
    return request(
      () => _packagesApi.fetchPackageDetail(pkgId: pkgId, shopId: shopId),
    );
  }

  @override
  Future<Resource> cancelFindingShipper(String shopId) {
    PackageDispatchRequest body = PackageDispatchRequest.create(
      type: PackageDispatchType.cancel.name,
      shopId: shopId,
    );
    return request(() => _packagesApi.dispatch(body));
  }

  @override
  Future<Resource> findShipper(String shopId) {
    PackageDispatchRequest body = PackageDispatchRequest.create(
      type: PackageDispatchType.find.name,
      shopId: shopId,
    );
    return request(() => _packagesApi.dispatch(body));
  }
}
