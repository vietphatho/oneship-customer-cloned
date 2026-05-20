import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/finance/data/models/response/finance_response.dart';
import 'package:oneship_customer/features/finance/data/models/response/settlement_periods_response.dart';
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

  @GET("/api/v1/financial/settlement/shops/{shopId}/periods")
  Future<BaseResponse<SettlementPeriodsResponse, BaseError>>
  fetchSettlementPeriods({
    @Path("shopId") required String shopId,
    @Query("page") required int page,
    @Query("limit") required int limit,
  });

  @GET("/api/v1/financial/settlement/shops/{shopId}/periods")
  Future<BaseResponse<SettlementPeriodsResponse, BaseError>>
  fetchSettlementPeriodsWithStatus({
    @Path("shopId") required String shopId,
    @Query("page") required int page,
    @Query("limit") required int limit,
    @Query("status") required String status,
  });
}
