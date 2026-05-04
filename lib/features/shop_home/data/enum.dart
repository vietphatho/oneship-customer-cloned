import 'package:flutter/material.dart';
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
    ShopHomeFeature.supporting: RouteName.packagesPage,
  };

  static const _mapIcon = {
    ShopHomeFeature.createSingleOrder: Icons.add_box_rounded,
    ShopHomeFeature.createMultiOrder: Icons.add_to_photos_rounded,
    ShopHomeFeature.orders: Icons.category_rounded,
    ShopHomeFeature.package: Icons.card_travel_rounded,
    ShopHomeFeature.ordersHistory: Icons.history_rounded,
    ShopHomeFeature.supporting: Icons.support_agent_rounded,
  };

  static const _mapTitle = {
    ShopHomeFeature.createSingleOrder: "create_order",
    ShopHomeFeature.createMultiOrder: "Create_multi_order",
    ShopHomeFeature.orders: "Processing_orders",
    ShopHomeFeature.ordersHistory: "Order_history",
    ShopHomeFeature.package: "Packages",
    ShopHomeFeature.supporting: "Support",
  };

  String get routeName => _mapRouteName[this]!;

  IconData get icon => _mapIcon[this]!;

  String get title => _mapTitle[this]!;
}
