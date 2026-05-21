enum UserRole { shop, customer }

extension UserRoleX on UserRole {
  static const _mapValue = {
    UserRole.shop: "shop",
    // UserRole.shipper: "shipper",
    UserRole.customer: "customer",
    // UserRole.guest: "guest",
  };

  static const _mapName = {
    UserRole.shop: "shop_owner",
    // UserRole.shipper: "shipper",
    UserRole.customer: "customer",
    // UserRole.guest: "guest",
  };

  String get value => _mapValue[this]!;

  String get roleName => _mapName[this]!;
}
