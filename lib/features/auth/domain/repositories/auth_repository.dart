import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/auth/data/models/request/login_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/register_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_user_profile_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/response/login_response.dart';
import 'package:oneship_customer/features/auth/data/models/response/user_profile_response.dart';

abstract class AuthRepository extends BaseRepository {
  Future<Resource<LoginResponse>> login(LoginRequest body);

  Future<Resource<UserProfileResponse>> fetchUserProfile();

  Future<Resource> logout();

  Future<Resource> registerAccount(RegisterRequest body);

  Future<Resource<UserProfileResponse>> updateUserProfile({
    required String id,
    required UpdateUserProfileRequest body,
  });

  Future<Resource> updatePassword(UpdatePasswordRequest body);
  Future<Resource> createSecondPassword(CreateSecondPasswordRequest body);
  Future<Resource> updateSecondPassword(UpdateSecondPasswordRequest body);

  // Future<Resource<OtpResult>> genOtpCode(String phoneNumber);

  // Future<Resource> updateFcmToken(UpdateFcmTokenRequest requestBody);
}
