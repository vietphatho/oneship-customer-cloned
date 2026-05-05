import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';
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
    @Query(Constants.statusQuery) required String status,
    @Query(Constants.shopIdQuery) required String shopId,
  });

  @GET("/api/v1/orders/{orderId}")
  Future<BaseResponse<OrderDetailResponse, BaseError>> fetchOrderDetail({
    @Path("orderId") required String orderId,
    @Query(Constants.shopIdQuery) required String shopId,
  });

  @GET("/api/v1/archives/orders")
  Future<BaseResponse<OrdersListResponse, BaseError>> fetchOrderHistory({
    @Query(Constants.statusQuery) required String status,
    @Query(Constants.shopIdQuery) required String shopId,
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

  @DELETE("/api/v1/orders/{orderId}")
  Future<BaseResponse> deleteOrder({
    @Path("orderId") required String orderId,
    @Query(Constants.shopIdQuery) required String shopId,
    @Query(Constants.statusQuery) required String status,
  });
}
