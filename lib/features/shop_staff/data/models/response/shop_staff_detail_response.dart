import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_staff_detail_response.freezed.dart';
part 'shop_staff_detail_response.g.dart';

@freezed
abstract class ShopStaffDetailResponse with _$ShopStaffDetailResponse {
  const factory ShopStaffDetailResponse({
    @JsonKey(name: "staffId") String? staffId,
    @JsonKey(name: "disabled") bool? disabled,
    @JsonKey(name: "user") ShopStaffUserResponse? user,
    @JsonKey(name: "shop") ShopStaffShopResponse? shop,
    @JsonKey(name: "role") String? role,
    @JsonKey(name: "permissions")
    Map<String, Map<String, bool>>? permissions,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _ShopStaffDetailResponse;

  factory ShopStaffDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffDetailResponseFromJson(json);
}

@freezed
abstract class ShopStaffUserResponse with _$ShopStaffUserResponse {
  const factory ShopStaffUserResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "userLogin") String? userLogin,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userEmail") String? userEmail,
    @JsonKey(name: "userPhone") String? userPhone,
    @JsonKey(name: "userStatus") String? userStatus,
  }) = _ShopStaffUserResponse;

  factory ShopStaffUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffUserResponseFromJson(json);
}

@freezed
abstract class ShopStaffShopResponse with _$ShopStaffShopResponse {
  const factory ShopStaffShopResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "status") String? status,
  }) = _ShopStaffShopResponse;

  factory ShopStaffShopResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffShopResponseFromJson(json);
}
