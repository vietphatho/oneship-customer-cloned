import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/finance_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/period_detail_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_config_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_payouts_response.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_periods_response.dart';
import 'package:retrofit/retrofit.dart';

part 'finance_api.g.dart';

@lazySingleton
@RestApi()
abstract class VendorFinanceApi {
  @factoryMethod
  factory VendorFinanceApi(Dio dio) = _VendorFinanceApi;

  @GET("/api/v1/marketplace/vendor/financial/summary")
  Future<BaseResponse<VendorFinanceResponse, BaseError>>
  fetchVendorFinancialSummary({
    @Query("userId") required String userId,
    @Query("startDate") required String startDate,
    @Query("endDate") required String endDate,
  });

  @GET("/api/v1/marketplace/vendor/financial/settlement/periods")
  Future<BaseResponse<SettlementPeriodsResponse, BaseError>>
  fetchSettlementPeriods({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("status") String? status,
    @Query("periodType") String? periodType,
    @Query("userId") required String userId,
  });

  @GET("/api/v1/marketplace/vendor/financial/settlement/periods/{id}")
  Future<BaseResponse<PeriodDetailResponse, BaseError>> fetchPeriodsDetail({
    @Path("id") required String id,
    @Query("userId") required String userId,
  });

  @GET("/api/v1/marketplace/vendor/financial/settlement/config")
  Future<BaseResponse<SettlementConfigResponse, BaseError>>
  fetchSettlementConfig({@Query("userId") required String userId});

  @GET("/api/v1/marketplace/vendor/financial/settlement/payouts")
  Future<BaseResponse<SettlementPayoutsResponse, BaseError>>
  fetchSettlementPayouts({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("status") String? status,
    @Query("userId") required String userId,
  });
}
