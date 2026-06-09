import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

enum ShopHomeFeature {
  createOrder,
  package,
  ordersProcessed,
  staffManagement,
  shopManagement,
  supporting,
}

extension ShopHomeFeatureExt on ShopHomeFeature {
  static const _mapRouteName = {
    ShopHomeFeature.createOrder: RouteName.createOrderPage,
    ShopHomeFeature.package: RouteName.packagesPage,
    ShopHomeFeature.ordersProcessed: RouteName.ordersHistoryPage,
    ShopHomeFeature.staffManagement: RouteName.staffManagementPage,
    ShopHomeFeature.shopManagement: RouteName.shopManagementPage,
    ShopHomeFeature.supporting: RouteName.complaintPage,
  };

  static const _mapIcon = {
    ShopHomeFeature.createOrder: SvgPath.icShopHomeCreateOrder,
    ShopHomeFeature.package: SvgPath.icShopHomePackage,
    ShopHomeFeature.ordersProcessed: SvgPath.icShopHomeOrderProcessed,
    ShopHomeFeature.staffManagement: SvgPath.icShopHomeStaff,
    ShopHomeFeature.shopManagement: SvgPath.icShopHomeShop,
    ShopHomeFeature.supporting: SvgPath.icShopHomeSupport,
  };

  static const _mapTitle = {
    ShopHomeFeature.createOrder: "create_order",
    ShopHomeFeature.package: "packages",
    ShopHomeFeature.ordersProcessed: "completed_orders",
    ShopHomeFeature.staffManagement: "shop_management.staff_title",
    ShopHomeFeature.shopManagement: "shop_management.title",
    ShopHomeFeature.supporting: "support",
  };

  String get routeName => _mapRouteName[this]!;

  String get icon => _mapIcon[this]!;

  String get title => _mapTitle[this]!;
}

enum ShopStatus { active, pending, unknown }

extension ShopStatusX on ShopStatus {
  static const _mapRawValue = {
    ShopStatus.active: "active",
    ShopStatus.pending: "pending",
    ShopStatus.unknown: "",
  };

  static const _mapLabel = {
    ShopStatus.active: 'shop_management.status_active',
    ShopStatus.pending: 'shop_management.status_pending',
    ShopStatus.unknown: 'shop_management.status_inactive',
  };

  static const _mapBgColorStatus = {
    ShopStatus.active: AppColors.active,
    ShopStatus.pending: AppColors.inactive,
    ShopStatus.unknown: AppColors.neutral8,
  };

  String get rawValue => _mapRawValue[this]!;

  String get label => _mapLabel[this]!.tr();

  Color get bgColor => _mapBgColorStatus[this]!;

  static ShopStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return ShopStatus.active;
      case 'pending':
        return ShopStatus.pending;
      default:
        return ShopStatus.unknown;
    }
  }
}
