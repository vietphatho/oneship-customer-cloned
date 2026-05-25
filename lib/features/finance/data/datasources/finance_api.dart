import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/base_error.dart';
import 'package:oneship_shop/core/base/models/base_response.dart';
import 'package:oneship_shop/features/finance/data/models/response/finance_response.dart';
import 'package:oneship_shop/features/finance/data/models/response/period_detail_response.dart';
import 'package:oneship_shop/features/finance/data/models/response/settlement_config_response.dart';
import 'package:oneship_shop/features/finance/data/models/response/settlement_payouts_response.dart';
import 'package:oneship_shop/features/finance/data/models/response/settlement_periods_response.dart';
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
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("status") String? status,
  });

  @GET("/api/v1/financial/settlement/shops/{shopId}/periods/{id}")
  Future<BaseResponse<PeriodDetailResponse, BaseError>> fetchPeriodsDetail({
    @Path("shopId") required String shopId,
    @Path("id") required String id,
  });

  @GET("/api/v1/financial/settlement/shops/{shopId}/config")
  Future<BaseResponse<SettlementConfigResponse, BaseError>>
  fetchSettlementConfig({@Path("shopId") required String shopId});

  @GET("/api/v1/financial/settlement/shops/{shopId}/payouts")
  Future<BaseResponse<SettlementPayoutsResponse, BaseError>>
  fetchSettlementPayouts({
    @Path("shopId") required String shopId,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });
}
