import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor_home/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor_home/domain/repositories/vendor_home_repository.dart';

@lazySingleton
class FetchVendorProcessingOrdersUseCase {
  FetchVendorProcessingOrdersUseCase(this._repository);

  final VendorHomeRepository _repository;

  Future<Resource<VendorOrdersEntity>> call({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  }) {
    return _repository.fetchProcessingOrders(
      shopId: shopId,
      vendorId: vendorId,
      page: page,
      limit: limit,
      trackingCode: trackingCode,
    );
  }
}
