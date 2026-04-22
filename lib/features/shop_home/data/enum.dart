import 'package:oneship_customer/core/navigation/route_name.dart';

enum ShopHomeFeature { createSingleOrder, createMultiOrder, orders, package }

extension ShopHomeFeatureExt on ShopHomeFeature {
  static const _mapRouteName = {
    ShopHomeFeature.createSingleOrder: RouteName.createOrderPage,
    ShopHomeFeature.createMultiOrder: RouteName.createMultiOrdersPage,
    ShopHomeFeature.orders: RouteName.ordersPage,
    ShopHomeFeature.package: RouteName.packagesPage,
  };

  String get routeName => _mapRouteName[this]!;
}
