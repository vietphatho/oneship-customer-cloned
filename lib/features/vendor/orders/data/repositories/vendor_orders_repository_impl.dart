import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/orders/data/data_sources/vendor_orders_api.dart';
import 'package:oneship_customer/features/vendor/orders/data/models/response/vendor_orders_response.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/repositories/vendor_orders_repository.dart';

@LazySingleton(as: VendorOrdersRepository)
class VendorOrdersRepositoryImpl extends VendorOrdersRepository {
  VendorOrdersRepositoryImpl(this._api);

  final VendorOrdersApi _api;

  @override
  Future<Resource<VendorOrdersEntity>> fetchProcessingOrders({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  }) async {
    final response = await request<VendorOrdersResponse, BaseError>(
      () => _api.fetchProcessingOrders(
        shopId: shopId,
        vendorId: vendorId,
        page: page,
        limit: limit,
        trackingCode: trackingCode,
      ),
    );

    return response.parse(VendorOrdersEntity.fromDto);
  }

  @override
  Future<Resource<VendorOrdersEntity>> fetchArchivedOrders({
    required String shopId,
    required String vendorId,
    required int page,
    required int limit,
    String? trackingCode,
  }) async {
    final response = await request<VendorOrdersResponse, BaseError>(
      () => _api.fetchArchivedOrders(
        shopId: shopId,
        vendorId: vendorId,
        page: page,
        limit: limit,
        trackingCode: trackingCode,
      ),
    );

    return response.parse(VendorOrdersEntity.fromDto);
  }
}
