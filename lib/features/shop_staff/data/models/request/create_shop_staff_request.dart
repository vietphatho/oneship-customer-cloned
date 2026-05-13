class CreateShopStaffRequest {
  const CreateShopStaffRequest({
    required this.userLogin,
    required this.userPass,
    required this.displayName,
    required this.userEmail,
    required this.userPhone,
    required this.shopId,
    required this.permissions,
  });

  final String userLogin;
  final String userPass;
  final String displayName;
  final String userEmail;
  final String userPhone;
  final String shopId;
  final Map<String, Map<String, bool>> permissions;

  factory CreateShopStaffRequest.create({
    required String userLogin,
    required String userPass,
    required String displayName,
    required String userEmail,
    required String userPhone,
    required String shopId,
    Map<String, Map<String, bool>>? permissions,
  }) {
    return CreateShopStaffRequest(
      userLogin: userLogin,
      userPass: userPass,
      displayName: displayName,
      userEmail: userEmail,
      userPhone: userPhone,
      shopId: shopId,
      permissions: permissions ?? defaultPermissions(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userLogin": userLogin,
      "userPass": userPass,
      "displayName": displayName,
      "userEmail": userEmail,
      "userPhone": userPhone,
      "shopId": shopId,
      "permissions": permissions,
    };
  }

  static Map<String, Map<String, bool>> defaultPermissions() {
    return {
      "orders": _emptyPermission(),
      "staff": _emptyPermission(),
      "shops": _emptyPermission(),
      "financial": _emptyPermission(),
      "settings": _emptyPermission(),
    };
  }

  static Map<String, bool> _emptyPermission() {
    return {"view": false, "create": false, "update": false, "delete": false};
  }
}
