import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/repositories/vendor_orders_repository.dart';

@lazySingleton
class FetchVendorArchivedOrderDetailUseCase {
  FetchVendorArchivedOrderDetailUseCase(this._repository);

  final VendorOrdersRepository _repository;

  Future<Resource<OrderDetailEntity>> call({
    required String shopId,
    required String vendorId,
    required String orderId,
  }) {
    return _repository.fetchArchivedOrderDetail(
      shopId: shopId,
      vendorId: vendorId,
      orderId: orderId,
    );
  }
}
