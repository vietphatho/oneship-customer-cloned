import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/features/management/presentation/views/management_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/orders_page.dart';
import 'package:oneship_customer/features/packages/presentation/views/packages_page.dart';

enum BottomNavigationItem { orders, packages, management }

extension BottomNavigationItemExt on BottomNavigationItem {
  static const _mapIcon = {
    BottomNavigationItem.orders: CupertinoIcons.cube_box_fill,
    BottomNavigationItem.packages: CupertinoIcons.cart,
    BottomNavigationItem.management: CupertinoIcons.settings,
  };

  static const _mapPage = {
    BottomNavigationItem.orders: OrdersPage(),
    BottomNavigationItem.packages: PackagesPage(),
    BottomNavigationItem.management: ManagementPage(),
  };

  IconData get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
