import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/get_brief_shops_response.dart';

part 'get_brief_shops_entity.freezed.dart';

@freezed
abstract class GetBriefShopsEntity with _$GetBriefShopsEntity {
  const factory GetBriefShopsEntity({
    @Default([]) List<BriefShopEntity> data,
    BaseMetaResponse? meta,
  }) = _GetBriefShopsEntity;

  factory GetBriefShopsEntity.from(GetBriefShopsResponse dto) {
    return GetBriefShopsEntity(
      data: dto.data?.map((e) => BriefShopEntity.from(e)).toList() ?? [],
      meta: dto.meta,
    );
  }
}

@freezed
abstract class BriefShopEntity with _$BriefShopEntity {
  const BriefShopEntity._();

  const factory BriefShopEntity({
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
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
  }) = _BriefShopEntity;

  bool get isActive => shopStatus?.trim().toLowerCase() == 'active';

  factory BriefShopEntity.from(ShopInfo dto) {
    return BriefShopEntity(
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
      phone: dto.profile?.phone,
      email: dto.profile?.email,
      address: dto.profile?.fullAddress,
      createdAt: dto.createdAt,
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
