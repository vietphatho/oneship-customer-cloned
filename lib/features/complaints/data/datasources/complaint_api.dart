import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/complaints/data/models/complaint_model.dart';
import 'package:oneship_customer/features/complaints/data/models/response/complaint_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'complaint_api.g.dart';

@lazySingleton
@RestApi()
abstract class ComplaintApi {
  @factoryMethod
  factory ComplaintApi(Dio dio) = _ComplaintApi;

  @GET("/api/v1/support-tickets")
  Future<BaseResponse<ComplaintListResponse, BaseError>> getComplaints({
    @Query("category") required String category,
    @Query("shopId") String? shopId,
  });

  @POST("/api/v1/support-tickets")
  Future<BaseResponse<ComplaintModel, BaseError>> createComplaint({
    @Body() required Map<String, dynamic> body,
  });

  @DELETE("/api/v1/support-tickets/{id}")
  Future<BaseResponse<bool, BaseError>> deleteComplaint(@Path("id") String id);
}
