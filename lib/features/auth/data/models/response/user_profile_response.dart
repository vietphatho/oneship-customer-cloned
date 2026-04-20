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
    @JsonKey(name: "roleId") int? roleId,
    @JsonKey(name: "role") Role? role,
    @JsonKey(name: "hasSecondPassword") bool? hasSecondPassword,
    @JsonKey(name: "profile") Profile? profile,
  }) = _UserProfileResponse;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile() = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
abstract class Role with _$Role {
  const factory Role({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "roleName") String? roleName,
    @JsonKey(name: "roleDisplayName") String? roleDisplayName,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
