import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';

abstract class VendorOrdersRepository extends BaseRepository {
  Future<Resource<VendorOrdersEntity>> fetchProcessingOrders({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  });

  Future<Resource<VendorOrdersEntity>> fetchArchivedOrders({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  });
}
