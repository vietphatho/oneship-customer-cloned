import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'get_brief_shops_response.freezed.dart';
part 'get_brief_shops_response.g.dart';

@freezed
abstract class GetBriefShopsResponse with _$GetBriefShopsResponse {
  const factory GetBriefShopsResponse({
    @JsonKey(name: "items") List<ShopInfo>? data,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _GetBriefShopsResponse;

  factory GetBriefShopsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBriefShopsResponseFromJson(json);
}

@freezed
abstract class ShopInfo with _$ShopInfo {
  const factory ShopInfo({
    @JsonKey(name: "staffId") String? staffId,
    @JsonKey(name: "userId") String? userId,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "shopStatus") String? shopStatus,
    @JsonKey(name: "shopCoordinates") BaseCoordinates? shopCoordinates,
    @JsonKey(name: "shopLogo") String? shopLogo,
    @JsonKey(name: "staffRole") String? staffRole,
    @JsonKey(name: "permissions") Map<String, ShopPermission>? permissions,
    @JsonKey(name: "isHub") bool? isHub,
    @JsonKey(name: "hasSecondPassword") bool? hasSecondPassword,
    @JsonKey(name: "profile") ShopProfile? profile,
    @JsonKey(name: "createdAt") DateTime? createdAt,
  }) = _ShopInfo;

  factory ShopInfo.fromJson(Map<String, dynamic> json) =>
      _$ShopInfoFromJson(json);
}

@freezed
abstract class ShopPermission with _$ShopPermission {
  const factory ShopPermission({
    @JsonKey(name: "view") bool? view,
    @JsonKey(name: "create") bool? create,
    @JsonKey(name: "update") bool? update,
    @JsonKey(name: "delete") bool? delete,
  }) = _ShopPermission;

  factory ShopPermission.fromJson(Map<String, dynamic> json) =>
      _$ShopPermissionFromJson(json);
}

@freezed
abstract class ShopProfile with _$ShopProfile {
  const factory ShopProfile({
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fullAddress") String? fullAddress,
  }) = _ShopProfile;

  factory ShopProfile.fromJson(Map<String, dynamic> json) =>
      _$ShopProfileFromJson(json);
}
