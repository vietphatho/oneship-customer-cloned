import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/repositories/vendor_orders_repository.dart';

@lazySingleton
class FetchVendorArchivedOrdersUseCase {
  FetchVendorArchivedOrdersUseCase(this._repository);

  final VendorOrdersRepository _repository;

  Future<Resource<VendorOrdersEntity>> call({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  }) {
    return _repository.fetchArchivedOrders(
      shopId: shopId,
      vendorId: vendorId,
      page: page,
      limit: limit,
      trackingCode: trackingCode,
    );
  }
}
