import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/vendor/profile/data/models/response/vendor_profile_response.dart';

part 'vendor_profile_entity.freezed.dart';

@freezed
abstract class VendorProfileEntity with _$VendorProfileEntity {
  const factory VendorProfileEntity({
    String? id,
    String? shopId,
    String? userId,
    String? vendorName,
    String? vendorCode,
    String? description,
    String? phone,
    String? email,
    String? fullAddress,
    int? wardCode,
    int? provinceCode,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _VendorProfileEntity;

  factory VendorProfileEntity.fromDto(VendorProfileResponse dto) {
    return VendorProfileEntity(
      id: dto.id,
      shopId: dto.shopId,
      userId: dto.userId,
      vendorName: dto.vendorName,
      vendorCode: dto.vendorCode,
      description: dto.description,
      phone: dto.phone,
      email: dto.email,
      fullAddress: dto.fullAddress,
      wardCode: dto.wardCode,
      provinceCode: dto.provinceCode,
      status: dto.status,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deletedAt: dto.deletedAt,
    );
  }
}
