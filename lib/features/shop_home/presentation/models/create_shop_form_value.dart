class CreateShopFormValue {
  const CreateShopFormValue({
    required this.shopName,
    required this.contactEmail,
    required this.phoneNumber,
    required this.provinceCode,
    required this.provinceName,
    required this.wardCode,
    required this.wardName,
    required this.fullAddress,
    required this.vietMapRefId,
  });

  final String shopName;
  final String contactEmail;
  final String phoneNumber;
  final int provinceCode;
  final String provinceName;
  final int wardCode;
  final String wardName;
  final String fullAddress;
  final String vietMapRefId;
}
