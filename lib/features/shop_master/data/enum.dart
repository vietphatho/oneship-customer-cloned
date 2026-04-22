import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/features/packages/presentation/views/packages_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_home.dart';

enum BottomNavigationItem { home, finance, management, menu }

extension BottomNavigationItemExt on BottomNavigationItem {
  static const _mapIcon = {
    BottomNavigationItem.home: CupertinoIcons.home,
    BottomNavigationItem.finance: CupertinoIcons.collections,
    BottomNavigationItem.management: CupertinoIcons.person_3,
    BottomNavigationItem.menu: CupertinoIcons.settings,
  };

  static const _mapPage = {
    BottomNavigationItem.home: ShopHome(),
    BottomNavigationItem.finance: PackagesPage(),
    BottomNavigationItem.management: ShopHome(),
    BottomNavigationItem.menu: ShopHome(),
  };

  IconData get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
