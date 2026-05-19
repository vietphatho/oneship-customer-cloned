import 'package:json_annotation/json_annotation.dart';

part 'shop_staff_list_response.g.dart';

@JsonSerializable()
class ShopStaffListResponse {
  final List<ShopStaffResponse>? items;
  final ShopStaffMetaResponse? meta;

  ShopStaffListResponse({this.items, this.meta});

  factory ShopStaffListResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopStaffListResponseToJson(this);
}

@JsonSerializable()
class ShopStaffResponse {
  final String? staffId;
  final String? userId;
  final String? shopId;
  final String? userLogin;
  final String? displayName;
  final String? userEmail;
  final String? userPhone;
  final String? userStatus;
  final String? shopName;
  final String? role;
  final bool? disabled;
  final String? createdAt;
  final String? updatedAt;

  ShopStaffResponse({
    this.staffId,
    this.userId,
    this.shopId,
    this.userLogin,
    this.displayName,
    this.userEmail,
    this.userPhone,
    this.userStatus,
    this.shopName,
    this.role,
    this.disabled,
    this.createdAt,
    this.updatedAt,
  });

  factory ShopStaffResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopStaffResponseToJson(this);
}

@JsonSerializable()
class ShopStaffMetaResponse {
  final String? page;
  final String? limit;
  final int? total;
  final int? totalPages;
  final bool? hasPrevious;
  final bool? hasNext;

  ShopStaffMetaResponse({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasPrevious,
    this.hasNext,
  });

  factory ShopStaffMetaResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopStaffMetaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopStaffMetaResponseToJson(this);
}
