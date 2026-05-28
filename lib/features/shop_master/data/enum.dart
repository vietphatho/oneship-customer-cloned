import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_order_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/orders_page.dart';
import 'package:oneship_customer/features/profile/presentation/views/general_profile_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_home.dart';

enum BottomNavigationItem {
  home,
  order,
  createOrder,
  finance,
  // staffManagement,
  // shopManagement,
  menu,
}

extension BottomNavigationItemExt on BottomNavigationItem {
  static const _mapIcon = {
    BottomNavigationItem.home: SvgPath.iconHome,
    BottomNavigationItem.order: SvgPath.iconOrder,
    BottomNavigationItem.createOrder: SvgPath.iconAdd,
    BottomNavigationItem.finance: SvgPath.iconFinance,
    // BottomNavigationItem.staffManagement: CupertinoIcons.person_3,
    // BottomNavigationItem.shopManagement: CupertinoIcons.shopping_cart,
    BottomNavigationItem.menu: SvgPath.iconMenu,
  };

  static const _mapPage = {
    BottomNavigationItem.home: ShopHome(),
    BottomNavigationItem.order: OrdersPage(),
    BottomNavigationItem.createOrder: CreateOrderPage(),
    BottomNavigationItem.finance: FinancePage(),
    // BottomNavigationItem.staffManagement: ShopStaffManagementPage(),
    // BottomNavigationItem.shopManagement: ShopManagementPage(),
    BottomNavigationItem.menu: GeneralProfilePage(),
  };

  String get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;

  // String get navLabelKey {
  //   switch (this) {
  //     case BottomNavigationItem.home:
  //       return 'bottom_navigation.home';
  //     case BottomNavigationItem.order:
  //       return 'bottom_navigation.finance';
  //     case BottomNavigationItem.createOrder:
  //       return 'bottom_navigation.finance';
  //     case BottomNavigationItem.finance:
  //       return 'bottom_navigation.finance';
  //     // case BottomNavigationItem.staffManagement:
  //     //   return 'bottom_navigation.staff';
  //     // case BottomNavigationItem.shopManagement:
  //     //   return 'bottom_navigation.shop';
  //     case BottomNavigationItem.menu:
  //       return 'bottom_navigation.more';
  //   }
  // }
}
