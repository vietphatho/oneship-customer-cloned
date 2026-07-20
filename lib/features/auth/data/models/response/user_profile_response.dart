import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';

part 'user_profile_response.freezed.dart';
part 'user_profile_response.g.dart';

enum UserStatus { active, inactive, unknown }

extension UserStatusX on UserStatus {
  static const _mapRawValue = {
    UserStatus.active: 'active',
    UserStatus.inactive: 'inactive',
    UserStatus.unknown: 'unknown',
  };

  String get rawValue => _mapRawValue[this]!;

  static UserStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      default:
        return UserStatus.unknown;
    }
  }

  static String toJson(UserStatus status) => status.rawValue;
}

@freezed
abstract class UserProfileResponse with _$UserProfileResponse {
  const factory UserProfileResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "userLogin") String? userLogin,
    @JsonKey(name: "userCode") String? userCode,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userEmail") String? userEmail,
    @Default(UserStatus.unknown)
    @JsonKey(
      name: "userStatus",
      fromJson: UserStatusX.fromString,
      toJson: UserStatusX.toJson,
    )
    UserStatus userStatus,
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

extension UserProfileResponseX on UserProfileResponse {
  String? get fullAvatarUrl {
    if (avatarUrl == null) return null;
    return "${Constants.imgEndpoint}/$avatarUrl";
  }
}
