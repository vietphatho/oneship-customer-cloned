class ShopStaffDetailResponse {
  const ShopStaffDetailResponse({
    this.staffId,
    this.disabled,
    this.user,
    this.shop,
    this.role,
    this.permissions,
    this.createdAt,
    this.updatedAt,
  });

  final String? staffId;
  final bool? disabled;
  final ShopStaffUserResponse? user;
  final ShopStaffShopResponse? shop;
  final String? role;
  final Map<String, Map<String, bool>>? permissions;
  final String? createdAt;
  final String? updatedAt;

  factory ShopStaffDetailResponse.fromJson(Map<String, dynamic> json) {
    return ShopStaffDetailResponse(
      staffId: json["staffId"] as String?,
      disabled: json["disabled"] as bool?,
      user:
          json["user"] is Map<String, dynamic>
              ? ShopStaffUserResponse.fromJson(
                json["user"] as Map<String, dynamic>,
              )
              : null,
      shop:
          json["shop"] is Map<String, dynamic>
              ? ShopStaffShopResponse.fromJson(
                json["shop"] as Map<String, dynamic>,
              )
              : null,
      role: json["role"] as String?,
      permissions: _parsePermissions(json["permissions"]),
      createdAt: json["createdAt"] as String?,
      updatedAt: json["updatedAt"] as String?,
    );
  }

  static Map<String, Map<String, bool>> _parsePermissions(Object? value) {
    if (value is! Map<String, dynamic>) return {};

    return value.map((groupKey, groupValue) {
      if (groupValue is! Map<String, dynamic>) {
        return MapEntry(groupKey, <String, bool>{});
      }

      return MapEntry(
        groupKey,
        groupValue.map(
          (actionKey, actionValue) => MapEntry(actionKey, actionValue == true),
        ),
      );
    });
  }
}

class ShopStaffUserResponse {
  const ShopStaffUserResponse({
    this.id,
    this.userLogin,
    this.displayName,
    this.userEmail,
    this.userPhone,
    this.userStatus,
  });

  final String? id;
  final String? userLogin;
  final String? displayName;
  final String? userEmail;
  final String? userPhone;
  final String? userStatus;

  factory ShopStaffUserResponse.fromJson(Map<String, dynamic> json) {
    return ShopStaffUserResponse(
      id: json["id"] as String?,
      userLogin: json["userLogin"] as String?,
      displayName: json["displayName"] as String?,
      userEmail: json["userEmail"] as String?,
      userPhone: json["userPhone"] as String?,
      userStatus: json["userStatus"] as String?,
    );
  }
}

class ShopStaffShopResponse {
  const ShopStaffShopResponse({
    this.id,
    this.shopName,
    this.status,
  });

  final String? id;
  final String? shopName;
  final String? status;

  factory ShopStaffShopResponse.fromJson(Map<String, dynamic> json) {
    return ShopStaffShopResponse(
      id: json["id"] as String?,
      shopName: json["shopName"] as String?,
      status: json["status"] as String?,
    );
  }
}
