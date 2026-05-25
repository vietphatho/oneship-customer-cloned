import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/base_error.dart';
import 'package:oneship_shop/core/base/models/base_response.dart';
import 'package:oneship_shop/features/orders/data/models/response/shipper_info_response.dart';
import 'package:retrofit/retrofit.dart';

part 'shipper_api.g.dart';

@lazySingleton
@RestApi()
abstract class ShipperApi {
  @factoryMethod
  factory ShipperApi(Dio dio) = _ShipperApi;

  @GET("/api/v1/shippers/lookup/{shipperCode}")
  Future<BaseResponse<ShipperInfoResponse, BaseError>> getShipperByCode(
    @Path("shipperCode") String shipperCode,
  );
}
