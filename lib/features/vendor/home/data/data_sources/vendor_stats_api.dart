import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/vendor/home/data/models/response/vendor_stats_response.dart';
import 'package:retrofit/retrofit.dart';

part 'vendor_stats_api.g.dart';

@lazySingleton
@RestApi()
abstract class VendorStatsApi {
  @factoryMethod
  factory VendorStatsApi(Dio dio) = _VendorStatsApi;

  @GET('/api/v1/shops/{shopId}/vendors/{vendorId}/stats')
  Future<BaseResponse<VendorStatsResponse, BaseError>> fetchVendorStats({
    @Path('shopId') required String shopId,
    @Path('vendorId') required String vendorId,
    @Query('startDate') required String startDate,
    @Query('endDate') required String endDate,
  });
}
