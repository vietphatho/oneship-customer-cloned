class CreateShopEntity {
  const CreateShopEntity({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.status,
    required this.profile,
  });

  final String id;
  final String userId;
  final String shopName;
  final String status;
  final CreateShopProfileEntity profile;
}

class CreateShopProfileEntity {
  const CreateShopProfileEntity({
    required this.phone,
    required this.email,
    required this.fullAddress,
    required this.provinceCode,
    required this.provinceName,
    required this.wardCode,
    required this.wardName,
  });

  final String phone;
  final String email;
  final String fullAddress;
  final int provinceCode;
  final String provinceName;
  final int wardCode;
  final String wardName;
}
