import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_shop/core/base/constants/svg_path.dart';
import 'package:oneship_shop/core/navigation/route_name.dart';
import 'package:oneship_shop/core/themes/app_colors.dart';

enum ShopHomeFeature {
  createSingleOrder,
  // createMultiOrder,
  package,
  orders,
  ordersHistory,
  supporting,
}

extension ShopHomeFeatureExt on ShopHomeFeature {
  static const _mapRouteName = {
    ShopHomeFeature.createSingleOrder: RouteName.createOrderPage,
    // ShopHomeFeature.createMultiOrder: RouteName.createMultiOrdersPage,
    ShopHomeFeature.orders: RouteName.ordersPage,
    ShopHomeFeature.ordersHistory: RouteName.ordersHistoryPage,
    ShopHomeFeature.package: RouteName.packagesPage,
    ShopHomeFeature.supporting: RouteName.complaintPage,
  };

  static const _mapIcon = {
    ShopHomeFeature.createSingleOrder: SvgPath.icOrderSingle,
    // ShopHomeFeature.createMultiOrder: SvgPath.icOrderMultiple,
    ShopHomeFeature.orders: SvgPath.icOrderProcessing,
    ShopHomeFeature.package: SvgPath.icOrderBag,
    ShopHomeFeature.ordersHistory: SvgPath.icOrderProcessed,
    ShopHomeFeature.supporting: SvgPath.icOrderSupport,
  };

  static const _mapTitle = {
    ShopHomeFeature.createSingleOrder: "create_order",
    // ShopHomeFeature.createMultiOrder: "create_multi_order",
    ShopHomeFeature.orders: "processing_orders",
    ShopHomeFeature.ordersHistory: "order_history",
    ShopHomeFeature.package: "packages",
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
