import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';
import 'package:retrofit/retrofit.dart';

part 'management_api.g.dart';

@lazySingleton
@RestApi()
abstract class ManagementApi {
  @factoryMethod
  factory ManagementApi(Dio dio) = _ManagementApi;

  @GET("/api/v1/shop-staff/users/{user_id}/shops")
  Future<BaseResponse<GetShopsResponse, BaseError>> getShops(
    @Path("user_id") String userId,
  );
}
