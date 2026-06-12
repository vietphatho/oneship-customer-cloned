import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/complaints/data/models/complaint_model.dart';
import 'package:oneship_customer/features/complaints/data/models/response/complaint_list_response.dart';
import 'package:oneship_customer/features/complaints/data/models/request/create_complaint_request.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'complaint_api.g.dart';

@lazySingleton
@RestApi()
abstract class ComplaintApi {
  @factoryMethod
  factory ComplaintApi(Dio dio) = _ComplaintApi;

  @GET("/api/v1/support-tickets")
  Future<BaseResponse<ComplaintListResponse, BaseError>> getComplaints({
    @Query("category") String? category,
    @Query("shopId") String? shopId,
    @Query("status") String? status,
    @Query("keyword") String? keyword,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @POST("/api/v1/support-tickets")
  Future<BaseResponse<ComplaintModel, BaseError>> createComplaint({
    @Body() required CreateComplaintRequest body,
  });

  @DELETE("/api/v1/support-tickets/{id}")
  Future<BaseResponse<bool, BaseError>> deleteComplaint(@Path("id") String id);

  @GET("/api/v1/support-tickets/summary")
  Future<BaseResponse<dynamic, BaseError>> getComplaintSummary({
    @Query("shopId") String? shopId,
  });

  @GET("/api/v1/system/options/company-config")
  Future<BaseResponse<dynamic, BaseError>> getCompanyConfig();

  @GET("/api/v1/packages")
  Future<BaseResponse<PackagesListResponse, BaseError>> getAssignedPackages({
    @Query("status") String? status,
    @Query("limit") int? limit,
    @Query("shopId") String? shopId,
  });

  @GET("/api/v1/packages/active")
  Future<BaseResponse<PackagesListResponse, BaseError>> getActivePackages({
    @Query("limit") int? limit,
    @Query("sortBy") String? sortBy,
    @Query("sortOrder") String? sortOrder,
    @Query("shopId") String? shopId,
    @Query("page") int? page,
  });

  @GET("/api/v1/shops/{shopId}/meta/system")
  Future<BaseResponse<dynamic, BaseError>> getShopMetaSystem({
    @Path("shopId") required String shopId,
  });
}
