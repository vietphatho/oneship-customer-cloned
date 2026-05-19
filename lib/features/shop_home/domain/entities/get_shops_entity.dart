import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/get_shops_response.dart';

part 'get_shops_entity.freezed.dart';

@freezed
abstract class GetShopsEntity with _$GetShopsEntity {
  const GetShopsEntity._();

  const factory GetShopsEntity({
    @Default([]) List<ShopEntity> items,
    BaseMetaResponse? meta,
  }) = _GetShopsEntity;

  factory GetShopsEntity.from(GetShopsResponse dto) {
    return GetShopsEntity(
      items: dto.items?.map((e) => ShopEntity.from(e)).toList() ?? [],
      meta: dto.meta,
    );
  }
}

extension GetShopsEntityX on GetShopsEntity {
  bool get hasMoreData =>
      meta?.page != null && (meta?.page ?? 0) < (meta?.totalPages ?? 0);
}

@freezed
abstract class ShopEntity with _$ShopEntity {
  const ShopEntity._();

  const factory ShopEntity({
    String? id,
    String? shopName,
    BaseCoordinates? coordinates,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopProfileEntity? profile,
  }) = _ShopEntity;

  factory ShopEntity.from(Shop dto) {
    return ShopEntity(
      id: dto.id,
      shopName: dto.shopName,
      coordinates: dto.coordinates,
      status: dto.status,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      profile:
          dto.profile != null ? ShopProfileEntity.from(dto.profile!) : null,
    );
  }
}

@freezed
abstract class ShopProfileEntity with _$ShopProfileEntity {
  const ShopProfileEntity._();

  const factory ShopProfileEntity({
    String? id,
    String? description,
    String? logo,
    String? banner,
    String? phone,
    String? email,
    String? ownerName,
    String? fullAddress,
    int? provinceCode,
    String? provinceName,
    int? wardCode,
    String? wardName,
  }) = _ShopProfileEntity;

  factory ShopProfileEntity.from(ShopProfile dto) {
    return ShopProfileEntity(
      id: dto.id,
      description: dto.description,
      logo: dto.logo,
      banner: dto.banner,
      phone: dto.phone,
      email: dto.email,
      ownerName: dto.ownerName,
      fullAddress: dto.fullAddress,
      provinceCode: dto.provinceCode,
      provinceName: dto.provinceName,
      wardCode: dto.wardCode,
      wardName: dto.wardName,
    );
  }
}
