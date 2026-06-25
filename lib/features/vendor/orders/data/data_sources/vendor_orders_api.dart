import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';
import 'package:oneship_customer/features/vendor/orders/data/models/response/vendor_orders_response.dart';
import 'package:retrofit/retrofit.dart';

part 'vendor_orders_api.g.dart';

@lazySingleton
@RestApi()
abstract class VendorOrdersApi {
  @factoryMethod
  factory VendorOrdersApi(Dio dio) = _VendorOrdersApi;

  @GET('/api/v1/shops/{shopId}/vendors/{vendorId}/orders')
  Future<BaseResponse<VendorOrdersResponse, BaseError>> fetchProcessingOrders({
    @Path('shopId') required String shopId,
    @Path('vendorId') required String vendorId,
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('trackingCode') String? trackingCode,
  });

  @GET('/api/v1/shops/{shopId}/vendors/{vendorId}/orders-archive')
  Future<BaseResponse<VendorOrdersResponse, BaseError>> fetchArchivedOrders({
    @Path('shopId') required String shopId,
    @Path('vendorId') required String vendorId,
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('trackingCode') String? trackingCode,
  });

  @GET('/api/v1/shops/{shopId}/vendors/{vendorId}/orders/{orderId}')
  Future<BaseResponse<OrderDetailResponse, BaseError>> fetchOrderDetail({
    @Path('shopId') required String shopId,
    @Path('vendorId') required String vendorId,
    @Path('orderId') required String orderId,
  });

  @GET('/api/v1/shops/{shopId}/vendors/{vendorId}/orders-archive/{orderId}')
  Future<BaseResponse<OrderDetailResponse, BaseError>>
  fetchArchivedOrderDetail({
    @Path('shopId') required String shopId,
    @Path('vendorId') required String vendorId,
    @Path('orderId') required String orderId,
  });
}
