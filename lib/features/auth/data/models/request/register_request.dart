import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    @JsonKey(name: "userLogin") String? userLogin,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userEmail") String? userEmail,
    @JsonKey(name: "userPhone") String? userPhone,
    @JsonKey(name: "userPass") String? userPass,
    @JsonKey(name: "roleName") String? roleName,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
