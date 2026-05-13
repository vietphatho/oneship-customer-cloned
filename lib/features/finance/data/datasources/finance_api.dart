import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/finance/data/models/response/finance_response.dart';
import 'package:retrofit/retrofit.dart';

part 'finance_api.g.dart';

@lazySingleton
@RestApi()
abstract class FinanceApi {
  @factoryMethod
  factory FinanceApi(Dio dio) = _FinanceApi;

  @GET("/api/v1/financial/shops/{shopId}/summary")
  Future<BaseResponse<FinanceResponse, BaseError>> fetchShopFinancial({
    @Path("shopId") required String shopId,
    @Query("startDate") required String startDate,
    @Query("endDate") required String endDate,
  });
}
