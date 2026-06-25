class ShopVendorResponse {
  const ShopVendorResponse({
    this.id,
    this.shopId,
    this.userId,
    this.vendorName,
    this.vendorCode,
    this.description,
    this.phone,
    this.email,
    this.fullAddress,
    this.wardCode,
    this.provinceCode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String? id;
  final String? shopId;
  final String? userId;
  final String? vendorName;
  final String? vendorCode;
  final String? description;
  final String? phone;
  final String? email;
  final String? fullAddress;
  final int? wardCode;
  final int? provinceCode;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory ShopVendorResponse.fromJson(Map<String, dynamic> json) {
    return ShopVendorResponse(
      id: json['id'] as String?,
      shopId: json['shopId'] as String?,
      userId: json['userId'] as String?,
      vendorName: json['vendorName'] as String?,
      vendorCode: json['vendorCode'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      fullAddress: json['fullAddress'] as String?,
      wardCode: json['wardCode'] as int?,
      provinceCode: json['provinceCode'] as int?,
      status: json['status'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      deletedAt: DateTime.tryParse(json['deletedAt'] as String? ?? ''),
    );
  }
}
