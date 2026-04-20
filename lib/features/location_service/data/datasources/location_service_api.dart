import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:retrofit/retrofit.dart';

part 'location_service_api.g.dart';

@lazySingleton
@RestApi()
abstract class LocationServiceApi {
  @factoryMethod
  factory LocationServiceApi(Dio dio) = _LocationServiceApi;

  @GET("/api/v1/vietmap/autocomplete")
  Future<BaseResponse<List<SuggestedAddressResponse>, BaseError>>
  searchAddress({
    @Query("city") required String province,
    @Query("ward") required String ward,
    @Query("provinceCode") required int provinceCode,
    @Query("wardCode") required int wardCode,
    @Query("display_type") required int displayType,
    @Query("address") String address = "",
  });
}
