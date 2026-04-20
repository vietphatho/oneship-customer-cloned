import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api.g.dart';

@lazySingleton
@RestApi()
abstract class OrdersApi {
  @factoryMethod
  factory OrdersApi(Dio dio) = _OrdersApi;

  @GET("/api/v1/orders")
  Future<BaseResponse<OrdersListResponse, BaseError>> fetchOrdersByStatus({
    @Query("status") required String status,
    @Query("shopId") required String shopId,
  });

  @GET("/api/v1/onexmaps/place-and-route")
  Future<BaseResponse<GetRoutingToShopResponse, BaseError>> getRoutingToShop({
    @Query("coordinates") required List<double> coordinates,
    @Query("vietMapRefId") required String destinationRefId,
    @Query("vehicle") required String vehicle,
  });

  @POST("/api/v1/orders/calculate-delivery-fee")
  Future<BaseResponse<CalculateDeliveryFeeResponse, BaseError>>
  calculateDeliveryFee(@Body() CalculateDeliveryFeeRequest body);

  @POST("/api/v1/orders")
  Future<BaseResponse> createOrder(@Body() CreateOrderRequest body);
}
