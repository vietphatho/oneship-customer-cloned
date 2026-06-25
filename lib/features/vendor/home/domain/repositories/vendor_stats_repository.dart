import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/home/data/models/request/vendor_stats_request.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';

abstract class VendorStatsRepository extends BaseRepository {
  Future<Resource<VendorStats>> fetchVendorStats(VendorStatsRequest request);
}
