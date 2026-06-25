import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor_home/data/data_sources/vendor_home_api.dart';
import 'package:oneship_customer/features/vendor_home/data/models/response/vendor_orders_response.dart';
import 'package:oneship_customer/features/vendor_home/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor_home/domain/repositories/vendor_home_repository.dart';

@LazySingleton(as: VendorHomeRepository)
class VendorHomeRepositoryImpl extends VendorHomeRepository {
  VendorHomeRepositoryImpl(this._api);

  final VendorHomeApi _api;

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
