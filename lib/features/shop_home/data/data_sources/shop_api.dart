import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/get_shops_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/request/create_shop_request.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/create_shop_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/shop_daily_summary_response.dart';
import 'package:retrofit/retrofit.dart';

part 'shop_api.g.dart';

@lazySingleton
@RestApi()
abstract class ShopApi {
  @factoryMethod
  factory ShopApi(Dio dio) = _ShopApi;

  @GET("/api/v1/shop-staff/users/{user_id}/shops")
  Future<BaseResponse<GetShopsResponse, BaseError>> getShops(
    @Path("user_id") String userId,
  );

  @GET("/api/v1/statistics/shop/{shopId}/daily-summary")
  Future<BaseResponse<ShopDailySummaryResponse, BaseError>>
  fetchShopDailySummary(@Path("shopId") String shopId);

  @POST("/api/v1/shops")
  Future<BaseResponse<CreateShopResponse, BaseError>> createShop(
    @Body() CreateShopRequest body,
  );
}
