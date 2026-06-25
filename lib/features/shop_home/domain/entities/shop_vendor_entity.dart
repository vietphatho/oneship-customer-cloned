import 'package:oneship_customer/features/shop_home/data/models/response/shop_vendor_response.dart';

class ShopVendorEntity {
  const ShopVendorEntity({
    required this.id,
    required this.shopId,
    required this.userId,
    required this.vendorName,
    required this.vendorCode,
    required this.description,
    required this.phone,
    required this.email,
    required this.fullAddress,
    required this.wardCode,
    required this.provinceCode,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String shopId;
  final String userId;
  final String vendorName;
  final String vendorCode;
  final String description;
  final String phone;
  final String email;
  final String fullAddress;
  final int? wardCode;
  final int? provinceCode;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory ShopVendorEntity.from(ShopVendorResponse dto) {
    return ShopVendorEntity(
      id: dto.id ?? '',
      shopId: dto.shopId ?? '',
      userId: dto.userId ?? '',
      vendorName: dto.vendorName ?? '',
      vendorCode: dto.vendorCode ?? '',
      description: dto.description ?? '',
      phone: dto.phone ?? '',
      email: dto.email ?? '',
      fullAddress: dto.fullAddress ?? '',
      wardCode: dto.wardCode,
      provinceCode: dto.provinceCode,
      status: dto.status ?? '',
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deletedAt: dto.deletedAt,
    );
  }
}
