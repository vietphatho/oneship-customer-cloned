import 'package:oneship_customer/features/shop_staff/data/models/response/shop_staff_detail_response.dart';

class ShopStaffDetailEntity {
  const ShopStaffDetailEntity({
    required this.staffId,
    required this.disabled,
    required this.userId,
    required this.userLogin,
    required this.displayName,
    required this.userEmail,
    required this.userPhone,
    required this.userStatus,
    required this.shopId,
    required this.shopName,
    required this.shopStatus,
    required this.role,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  final String staffId;
  final bool disabled;
  final String userId;
  final String userLogin;
  final String displayName;
  final String userEmail;
  final String userPhone;
  final String userStatus;
  final String shopId;
  final String shopName;
  final String shopStatus;
  final String role;
  final Map<String, Map<String, bool>> permissions;
  final String createdAt;
  final String updatedAt;

  factory ShopStaffDetailEntity.fromResponse(
    ShopStaffDetailResponse response,
  ) {
    return ShopStaffDetailEntity(
      staffId: response.staffId ?? "",
      disabled: response.disabled ?? false,
      userId: response.user?.id ?? "",
      userLogin: response.user?.userLogin ?? "",
      displayName: response.user?.displayName ?? "",
      userEmail: response.user?.userEmail ?? "",
      userPhone: response.user?.userPhone ?? "",
      userStatus: response.user?.userStatus ?? "",
      shopId: response.shop?.id ?? "",
      shopName: response.shop?.shopName ?? "",
      shopStatus: response.shop?.status ?? "",
      role: response.role ?? "",
      permissions: response.permissions ?? const {},
      createdAt: response.createdAt ?? "",
      updatedAt: response.updatedAt ?? "",
    );
  }

  bool get isActive => !disabled && userStatus == "active";
  bool get isShopActive => shopStatus == "active";
}
