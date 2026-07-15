import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/features/vendor/home/presentation/views/vendor_home_page.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/finance_page.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/views/vendor_orders_page.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/views/vendor_profile_page.dart';

enum VendorNavigationItem { home, orders, finance, profile }

extension VendorNavigationItemExt on VendorNavigationItem {
  static const _mapTitle = {
    VendorNavigationItem.home: 'vendor_master.home',
    VendorNavigationItem.orders: 'vendor_master.orders',
    VendorNavigationItem.finance: 'vendor_master.finance',
    VendorNavigationItem.profile: 'vendor_master.profile',
  };

  static const _mapIcon = {
    VendorNavigationItem.home: SvgPath.iconHome,
    VendorNavigationItem.orders: SvgPath.iconOrderList,
    VendorNavigationItem.finance: SvgPath.wallet,
    VendorNavigationItem.profile: SvgPath.iconMenu,
  };

  static const _mapPage = {
    VendorNavigationItem.home: VendorHomePage(),
    VendorNavigationItem.orders: VendorOrdersPage(),
    VendorNavigationItem.finance: VendorFinancePage(),
    VendorNavigationItem.profile: VendorProfilePage(),
  };

  String get title => _mapTitle[this]!.tr();

  String get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
