import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/get_shops_response.dart';

part 'get_shops_entity.freezed.dart';

@freezed
abstract class GetShopsEntity with _$GetShopsEntity {
  const factory GetShopsEntity({
    @Default([]) List<ShopEntity> data,
    BaseMetaResponse? meta,
  }) = _GetShopsEntity;

  factory GetShopsEntity.from(GetShopsResponse dto) {
    return GetShopsEntity(
      data: dto.data?.map((e) => ShopEntity.from(e)).toList() ?? [],
      meta: dto.meta,
    );
  }
}

@freezed
abstract class ShopEntity with _$ShopEntity {
  const factory ShopEntity({
    String? staffId,
    String? userId,
    String? shopId,
    @Default("") String shopName,
    String? shopStatus,
    BaseCoordinates? shopCoordinates,
    String? shopLogo,
    String? staffRole,
    @Default({}) Map<String, ShopPermissionEntity> permissions,
    @Default(false) bool isHub,
    @Default(false) bool hasSecondPassword,
  }) = _ShopEntity;

  factory ShopEntity.from(ShopInfo dto) {
    return ShopEntity(
      staffId: dto.staffId,
      userId: dto.userId,
      shopId: dto.shopId,
      shopName: dto.shopName ?? "",
      shopStatus: dto.shopStatus,
      shopCoordinates: dto.shopCoordinates,
      shopLogo: dto.shopLogo,
      staffRole: dto.staffRole,
      permissions:
          dto.permissions?.map(
            (key, value) => MapEntry(key, ShopPermissionEntity.from(value)),
          ) ??
          {},
      isHub: dto.isHub ?? false,
      hasSecondPassword: dto.hasSecondPassword ?? false,
    );
  }
}

@freezed
abstract class ShopPermissionEntity with _$ShopPermissionEntity {
  const factory ShopPermissionEntity({
    @Default(false) bool view,
    @Default(false) bool create,
    @Default(false) bool update,
    @Default(false) bool delete,
  }) = _ShopPermissionEntity;

  factory ShopPermissionEntity.from(ShopPermission dto) {
    return ShopPermissionEntity(
      view: dto.view ?? false,
      create: dto.create ?? false,
      update: dto.update ?? false,
      delete: dto.delete ?? false,
    );
  }
}
