import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/base_response.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/resend_verification_email_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_email_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/verify_secondary_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/login_response.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';
import 'package:oneship_customer/features/auth/data/models/response/verify_secondary_password_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

// run build runner to gen code

@lazySingleton
@RestApi()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST("/api/v1/auth/login")
  Future<BaseResponse<LoginResponse, BaseError>> login(
    @Body() LoginRequest body,
  );

  @GET("/api/v1/auth/me")
  Future<BaseResponse<UserProfileResponse, BaseError>> fetchUserProfile();

  @POST("/api/v1/auth/logout-session")
  Future<BaseResponse> logout();

  @POST("/api/v1/users")
  Future<BaseResponse> registerAccount(@Body() RegisterRequest body);

  @POST("/api/v1/auth/verify-email")
  Future<BaseResponse> verifyEmail(@Body() VerifyEmailRequest body);

  @POST("/api/v1/auth/resend-verification-email")
  Future<BaseResponse> resendVerificationEmail(@Body() ResendVerificationEmailRequest body);
  
  @PATCH("/api/v1/users/{id}")
  Future<BaseResponse<UserProfileResponse, BaseError>> updateUserProfile({
    @Path("id") required String id,
    @Body() required UpdateUserProfileRequest body,
  });

  @POST("/api/v1/auth/verify-second-password")
  Future<BaseResponse<VerifySecondaryPasswordResponse, BaseError>>
  verifySecondaryPassword(@Body() VerifySecondaryPasswordRequest body);

  // //gen otp code
  // @POST("/api/v1/auth/shipper/register-otp")
  // Future<BaseResponse<OtpResult, OtpError>> genOtpCode(
  //   @Body() Map<String, dynamic> body,
  // );

  // @POST("/api/v1/fcm-token")
  // Future<BaseResponse> updateFcmToken(
  //   @Body() UpdateFcmTokenRequest requestBody,
  // );
}
