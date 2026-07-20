import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';

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
    required Resource<List<SurchargeGroupEntity>>
    visibleSurchargeGroupsResource,
    required Resource<List<OrderOptionEntity>> commodityTypesResource,
    required Resource<List<OrderOptionEntity>> handlingTypesResource,
    required Resource<List<ShopVendorEntity>> shopVendorsResource,
    required Resource<PromotionsPageEntity> promotionsResource,
    required Resource<PromotionsPageEntity> newsResource,
    BriefShopEntity? currentShop,
    BriefShopEntity? draftSelectedShop,
    @Default([]) List<BriefShopEntity> listBriefShops,
    @Default([]) List<BriefShopEntity> filteredShops,
    @Default([]) List<PromotionProgramEntity> listPromotions,
    @Default([]) List<PromotionProgramEntity> listNews,
  }) = _ShopState;
}

extension ShopStateX on ShopState {
  List<BriefShopEntity> get approvedBriefShops {
    // final shops = briefShopsResource.data?.data ?? const [];
    return listBriefShops.where((shop) => shop.isActive).toList();
  }

  List<ShippingServiceConfigEntity> get shippingServices =>
      shippingServiceTypesResource.data ?? [];

  List<SurchargeGroupEntity> get visibleSurchargeGroups =>
      visibleSurchargeGroupsResource.data ?? const [];

  List<SurchargeEntity> get visibleSurcharges =>
      visibleSurchargeGroups.visibleSurcharges;

  List<OrderOptionEntity> get commodityTypes =>
      commodityTypesResource.data ?? const [];

  List<OrderOptionEntity> get handlingTypes =>
      handlingTypesResource.data ?? const [];

  List<ShopVendorEntity> get shopVendors =>
      shopVendorsResource.data ?? const [];

  bool get hasApprovedShop {
    return approvedBriefShops.isNotEmpty;
  }

  bool get hasNoShops => briefShopsResource.data?.data.isEmpty ?? true;

  bool get hasNext => briefShopsResource.data?.meta?.hasNext == true;

  List<ShopEntity> get shopsList => shopsResource.data?.items ?? [];

  List<PromotionProgramEntity> get homePromotions =>
      listPromotions.take(5).toList();

  List<PromotionProgramEntity> get homeNews => listNews.take(3).toList();

  bool get hasMorePromotions => promotionsResource.data?.hasMore == true;
}
