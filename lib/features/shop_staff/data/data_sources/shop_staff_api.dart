import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/add_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/data/models/response/shop_staff_detail_response.dart';
import 'package:oneship_customer/features/shop_staff/data/models/response/shop_staff_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'shop_staff_api.g.dart';

@lazySingleton
@RestApi()
abstract class ShopStaffApi {
  @factoryMethod
  factory ShopStaffApi(Dio dio) = _ShopStaffApi;

  @GET("/api/v1/shop-staff/{shopId}/staff")
  Future<BaseResponse<ShopStaffListResponse, BaseError>> fetchShopStaffs({
    @Path("shopId") required String shopId,
    @Query("shopId") required String queryShopId,
    @Query("page") required int page,
    @Query("limit") required int limit,
    @Query("sortBy") String sortBy = Constants.defaultSortByCreatedAt,
    @Query("sortOrder") String sortOrder = Constants.defaultSortOrderDesc,
    @Query("displayName") String? displayName,
    @Query("userEmail") String? userEmail,
    @Query("userStatus") String? userStatus,
  });

  @POST("/api/v1/shop-staff/create")
  Future<BaseResponse> createShopStaff(@Body() CreateShopStaffRequest body);

  @POST("/api/v1/shop-staff/{shopId}/add-staff")
  Future<BaseResponse> addStaffToShop({
    @Path("shopId") required String shopId,
    @Body() required AddShopStaffRequest body,
  });

  @GET("/api/v1/shop-staff/{shopId}/staff/{staffId}")
  Future<BaseResponse<ShopStaffDetailResponse, BaseError>>
  fetchShopStaffDetail({
    @Path("shopId") required String shopId,
    @Path("staffId") required String staffId,
  });

  @PATCH("/api/v1/shop-staff/{shopId}/staff/{staffId}/toggle-disable")
  Future<BaseResponse> toggleDisableShopStaff({
    @Path("shopId") required String shopId,
    @Path("staffId") required String staffId,
  });
}
