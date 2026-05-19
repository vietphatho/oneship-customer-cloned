import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';

enum ShopHomeFeature {
  createSingleOrder,
  createMultiOrder,
  package,
  orders,
  ordersHistory,
  supporting,
}

extension ShopHomeFeatureExt on ShopHomeFeature {
  static const _mapRouteName = {
    ShopHomeFeature.createSingleOrder: RouteName.createOrderPage,
    ShopHomeFeature.createMultiOrder: RouteName.createMultiOrdersPage,
    ShopHomeFeature.orders: RouteName.ordersPage,
    ShopHomeFeature.ordersHistory: RouteName.ordersHistoryPage,
    ShopHomeFeature.package: RouteName.packagesPage,
    ShopHomeFeature.supporting: RouteName.complaintPage,
  };

  static const _mapIcon = {
    ShopHomeFeature.createSingleOrder: SvgPath.icOrderSingle,
    ShopHomeFeature.createMultiOrder: SvgPath.icOrderMultiple,
    ShopHomeFeature.orders: SvgPath.icOrderProcessing,
    ShopHomeFeature.package: SvgPath.icOrderBag,
    ShopHomeFeature.ordersHistory: SvgPath.icOrderProcessed,
    ShopHomeFeature.supporting: SvgPath.icOrderSupport,
  };

  static const _mapTitle = {
    ShopHomeFeature.createSingleOrder: "create_order",
    ShopHomeFeature.createMultiOrder: "create_multi_order",
    ShopHomeFeature.orders: "processing_orders",
    ShopHomeFeature.ordersHistory: "order_history",
    ShopHomeFeature.package: "packages",
    ShopHomeFeature.supporting: "support",
  };

  String get routeName => _mapRouteName[this]!;

  String get icon => _mapIcon[this]!;

  String get title => _mapTitle[this]!;
}
