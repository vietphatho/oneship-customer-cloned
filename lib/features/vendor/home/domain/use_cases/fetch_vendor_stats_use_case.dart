import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/home/data/models/request/vendor_stats_request.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/domain/repositories/vendor_stats_repository.dart';

@lazySingleton
class FetchVendorStatsUseCase {
  FetchVendorStatsUseCase(this._repository);

  final VendorStatsRepository _repository;

  Future<Resource<VendorStats>> call(VendorStatsRequest request) {
    return _repository.fetchVendorStats(request);
  }
}
