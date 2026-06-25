import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/vendor/profile/data/models/response/vendor_profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'vendor_profile_api.g.dart';

@lazySingleton
@RestApi()
abstract class VendorProfileApi {
  @factoryMethod
  factory VendorProfileApi(Dio dio) = _VendorProfileApi;

  @GET('/api/v1/users/vendor-profile')
  Future<BaseResponse<VendorProfileResponse, BaseError>> fetchVendorProfile();
}
