import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';

enum ShopHomeFeature {
  createOrder,
  package,
  ordersProcessed,
  pickupAddress,
  staffManagement,
  shopManagement,
  supporting,
  // settings,
  scanPatientCode,
}

extension ShopHomeFeatureExt on ShopHomeFeature {
  static const _mapRouteName = {
    ShopHomeFeature.createOrder: RouteName.createOrderPage,
    ShopHomeFeature.package: RouteName.packagesPage,
    ShopHomeFeature.ordersProcessed: RouteName.ordersHistoryPage,
    ShopHomeFeature.pickupAddress: null,
    ShopHomeFeature.staffManagement: RouteName.staffManagementPage,
    ShopHomeFeature.shopManagement: RouteName.shopManagementPage,
    ShopHomeFeature.supporting: RouteName.supportPage,
    // ShopHomeFeature.settings: null,
    ShopHomeFeature.scanPatientCode: RouteName.scanPatientCodePage,
  };

  static const _mapIcon = {
    ShopHomeFeature.createOrder: ImagePath.shopHomeIconCreateOrderGenerated,
    ShopHomeFeature.package: ImagePath.shopHomeIconPackageGenerated,
    ShopHomeFeature.ordersProcessed:
        ImagePath.shopHomeIconOrderProcessedGenerated,
    ShopHomeFeature.pickupAddress: ImagePath.shopHomeIconPickupAddressGenerated,
    ShopHomeFeature.staffManagement: ImagePath.shopHomeIconStaffGenerated,
    ShopHomeFeature.shopManagement: ImagePath.shopHomeIconShopGenerated,
    ShopHomeFeature.supporting: ImagePath.shopHomeIconSupportGenerated,
    // ShopHomeFeature.settings: ImagePath.shopHomeIconSettingsGenerated,
    ShopHomeFeature.scanPatientCode: ImagePath.iconPatientScan,
  };

  static const _mapTitle = {
    ShopHomeFeature.createOrder: "shop_home.feature_create_order",
    ShopHomeFeature.package: "shop_home.feature_package",
    ShopHomeFeature.ordersProcessed: "shop_home.feature_processed_orders",
    ShopHomeFeature.pickupAddress: "shop_home.feature_pickup_address",
    ShopHomeFeature.staffManagement: "shop_home.feature_staff_management",
    ShopHomeFeature.shopManagement: "shop_home.feature_shop_management",
    ShopHomeFeature.supporting: "shop_home.feature_complaint_incident",
    // ShopHomeFeature.settings: "shop_home.feature_settings",
    ShopHomeFeature.scanPatientCode: "shop_home.scan_patient_code",
  };

  String? get routeName => _mapRouteName[this];

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

enum ShopType { df, market, hospital }

extension ShopTypeX on ShopType {
  static const _mapValue = {
    ShopType.df: "default",
    ShopType.hospital: "hospital",
    ShopType.market: "market",
  };

  String get value => _mapValue[this]!;
}
