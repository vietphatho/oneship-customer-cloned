import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/home/data/data_sources/vendor_stats_api.dart';
import 'package:oneship_customer/features/vendor/home/data/models/request/vendor_stats_request.dart';
import 'package:oneship_customer/features/vendor/home/data/models/response/vendor_stats_response.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/domain/repositories/vendor_stats_repository.dart';

@LazySingleton(as: VendorStatsRepository)
class VendorStatsRepositoryImpl extends VendorStatsRepository {
  VendorStatsRepositoryImpl(this._api);

  final VendorStatsApi _api;

  @override
  Future<Resource<VendorStats>> fetchVendorStats(
    VendorStatsRequest request,
  ) async {
    final response = await requestGuard(request);
    return response.parse(VendorStats.fromDto);
  }

  Future<Resource<VendorStatsResponse>> requestGuard(
    VendorStatsRequest request,
  ) {
    return this.request<VendorStatsResponse, BaseError>(
      () => _api.fetchVendorStats(
        shopId: request.shopId,
        vendorId: request.vendorId,
        startDate: request.startDateText,
        endDate: request.endDateText,
      ),
    );
  }
}
