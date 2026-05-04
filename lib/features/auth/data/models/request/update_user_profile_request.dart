import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_profile_request.freezed.dart';
part 'update_user_profile_request.g.dart';

@freezed
abstract class UpdateUserProfileRequest with _$UpdateUserProfileRequest {
  const factory UpdateUserProfileRequest({
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userPhone") String? userPhone,
  }) = _UpdateUserProfileRequest;

  factory UpdateUserProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileRequestFromJson(json);
}
