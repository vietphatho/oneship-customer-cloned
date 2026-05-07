import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_page.dart';
import 'package:oneship_customer/features/profile/presentation/views/general_profile_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_home.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_management_page.dart';

enum BottomNavigationItem {
  home,
  finance,
  staffManagement,
  shopManagement,
  menu,
}

extension BottomNavigationItemExt on BottomNavigationItem {
  static const _mapIcon = {
    BottomNavigationItem.home: CupertinoIcons.home,
    BottomNavigationItem.finance: CupertinoIcons.money_dollar,
    BottomNavigationItem.staffManagement: CupertinoIcons.person_3,
    BottomNavigationItem.shopManagement: CupertinoIcons.shopping_cart,
    BottomNavigationItem.menu: CupertinoIcons.settings,
  };

  static const _mapPage = {
    BottomNavigationItem.home: ShopHome(),
    BottomNavigationItem.finance: FinancePage(),
    BottomNavigationItem.staffManagement: GeneralProfilePage(),
    BottomNavigationItem.shopManagement: ShopManagementPage(),
    BottomNavigationItem.menu: GeneralProfilePage(),
  };

  IconData get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
