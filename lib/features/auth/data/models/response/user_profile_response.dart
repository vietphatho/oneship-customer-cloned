import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_response.freezed.dart';
part 'user_profile_response.g.dart';

@freezed
abstract class UserProfileResponse with _$UserProfileResponse {
  const factory UserProfileResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "userLogin") String? userLogin,
    @JsonKey(name: "userCode") String? userCode,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userEmail") String? userEmail,
    @JsonKey(name: "userStatus") String? userStatus,
    @JsonKey(name: "userPhone") String? userPhone,
    @JsonKey(name: "avatarUrl") String? avatarUrl,
    @JsonKey(name: "coordinates") dynamic coordinates,
    @JsonKey(name: "userRegistered") dynamic userRegistered,
        @JsonKey(name: "userRole") String? userRole,
    @JsonKey(name: "hasSecondPassword") bool? hasSecondPassword,
    @JsonKey(name: "profile") Profile? profile,
  }) = _UserProfileResponse;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "wardName") String? wardName,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
