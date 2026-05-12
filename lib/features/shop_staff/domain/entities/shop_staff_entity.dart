import 'package:oneship_customer/features/shop_staff/data/models/response/shop_staff_list_response.dart';

class ShopStaffEntity {
  final String staffId;
  final String userId;
  final String shopId;
  final String userLogin;
  final String displayName;
  final String userEmail;
  final String userPhone;
  final String userStatus;
  final String shopName;
  final String role;
  final bool disabled;
  final String createdAt;
  final String updatedAt;

  ShopStaffEntity({
    required this.staffId,
    required this.userId,
    required this.shopId,
    required this.userLogin,
    required this.displayName,
    required this.userEmail,
    required this.userPhone,
    required this.userStatus,
    required this.shopName,
    required this.role,
    required this.disabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopStaffEntity.fromResponse(ShopStaffResponse response) {
    return ShopStaffEntity(
      staffId: response.staffId ?? "",
      userId: response.userId ?? "",
      shopId: response.shopId ?? "",
      userLogin: response.userLogin ?? "",
      displayName: response.displayName ?? "",
      userEmail: response.userEmail ?? "",
      userPhone: response.userPhone ?? "",
      userStatus: response.userStatus ?? "",
      shopName: response.shopName ?? "",
      role: response.role ?? "",
      disabled: response.disabled ?? false,
      createdAt: response.createdAt ?? "",
      updatedAt: response.updatedAt ?? "",
    );
  }

  bool get isActive => !disabled && userStatus == "active";

}
