import 'package:oneship_customer/features/shop_home/data/models/response/create_shop_response.dart';

class CreateShopEntity {
  const CreateShopEntity({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.status,
    required this.profile,
  });

  factory CreateShopEntity.fromDto(CreateShopResponse dto) {
    final profile = dto.profile;
    return CreateShopEntity(
      id: dto.id ?? '',
      userId: dto.userId ?? '',
      shopName: dto.shopName ?? '',
      status: dto.status ?? '',
      profile: CreateShopProfileEntity.fromDto(profile),
    );
  }

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

  factory CreateShopProfileEntity.fromDto(CreateShopProfileResponse? profile) {
    return CreateShopProfileEntity(
      phone: profile?.phone ?? '',
      email: profile?.email ?? '',
      fullAddress: profile?.fullAddress ?? '',
      provinceCode: profile?.provinceCode ?? 0,
      provinceName: profile?.provinceName ?? '',
      wardCode: profile?.wardCode ?? 0,
      wardName: profile?.wardName ?? '',
    );
  }

  final String phone;
  final String email;
  final String fullAddress;
  final int provinceCode;
  final String provinceName;
  final int wardCode;
  final String wardName;
}
