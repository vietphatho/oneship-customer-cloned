import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_page.dart';
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
    BottomNavigationItem.finance: FinancePage(),
    BottomNavigationItem.management: FinancePage(),
    BottomNavigationItem.menu: FinancePage(),
  };

  IconData get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
