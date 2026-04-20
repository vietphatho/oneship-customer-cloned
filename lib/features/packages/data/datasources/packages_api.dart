import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/packages/data/models/request/package_dispatch_request.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'packages_api.g.dart';

@lazySingleton
@RestApi()
abstract class PackagesApi {
  @factoryMethod
  factory PackagesApi(Dio dio) = _PackagesApi;

  @GET("/api/v1/packages")
  Future<BaseResponse<PackagesListResponse, BaseError>> fetchPackages({
    @Query("shopId") required String shopId,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET("/api/v1/packages/{pkg_id}")
  Future<BaseResponse<PackageDetail, BaseError>> fetchPackageDetail({
    @Path("pkg_id") required String pkgId,
    @Query("shopId") required String shopId,
  });

  @POST("/api/v1/packages/dispatch")
  Future<BaseResponse> dispatch(@Body() PackageDispatchRequest body);
}
