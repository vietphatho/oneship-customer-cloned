import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/order_tracking/data/models/request/order_tracking_request.dart';
import 'package:oneship_customer/features/order_tracking/data/models/response/order_tracking_response.dart';
import 'package:retrofit/retrofit.dart';

part 'order_tracking_api.g.dart';

@lazySingleton
@RestApi()
abstract class OrderTrackingApi {
  @factoryMethod
  factory OrderTrackingApi(Dio dio) = _OrderTrackingApi;

  @POST("/api/v1/orders/track")
  Future<BaseResponse<OrderTrackingResponse, BaseError>> trackingOrder(
    @Body() OrderTrackingRequest trackingCode,
  );
}
