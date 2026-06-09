import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/complaints/data/models/complaint_model.dart';
import 'package:oneship_customer/features/complaints/data/models/response/complaint_list_response.dart';
import 'package:oneship_customer/features/complaints/data/models/request/create_complaint_request.dart';
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
}
