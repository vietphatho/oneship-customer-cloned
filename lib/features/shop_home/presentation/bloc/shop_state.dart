import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';

part 'shop_state.freezed.dart';

@freezed
abstract class ShopState with _$ShopState {
  const ShopState._();

  const factory ShopState({
    @Default('') String userId,
    required Resource<ShopDailySummaryEntity> dailySummaryResource,
    required Resource<GetBriefShopsEntity> briefShopsResource,
    required Resource<CreateShopEntity> createShopResource,
    required Resource<GetShopsEntity> shopsResource,
    required Resource<List<ShippingServiceConfigEntity>>
    shippingServiceTypesResource,
    BriefShopEntity? currentShop,
    @Default([]) List<BriefShopEntity> filteredShops,
  }) = _ShopState;
}

extension ShopStateX on ShopState {
  List<BriefShopEntity> get approvedBriefShops {
    final shops = briefShopsResource.data?.data ?? const [];
    return shops.where((shop) => shop.isActive).toList();
  }

  List<ShippingServiceConfigEntity> get shippingServices =>
      shippingServiceTypesResource.data ?? [];

  bool get hasApprovedShop {
    return approvedBriefShops.isNotEmpty;
  }

  bool get hasNoShops => briefShopsResource.data?.data.isEmpty ?? true;

  List<ShopEntity> get shopsList => shopsResource.data?.items ?? [];
}
