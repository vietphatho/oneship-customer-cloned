class CreateShopParams {
  const CreateShopParams({
    required this.userId,
    required this.shopName,
    required this.phone,
    required this.email,
    required this.fullAddress,
    required this.provinceCode,
    required this.provinceName,
    required this.wardCode,
    required this.wardName,
    required this.vietMapRefId,
  });

  final String userId;
  final String shopName;
  final String phone;
  final String email;
  final String fullAddress;
  final int provinceCode;
  final String provinceName;
  final int wardCode;
  final String wardName;
  final String vietMapRefId;
}
