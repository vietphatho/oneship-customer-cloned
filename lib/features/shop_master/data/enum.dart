import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/features/finance/presentation/views/finance_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_order_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/orders_page.dart';
import 'package:oneship_customer/features/profile/presentation/views/general_profile_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_home.dart';
import 'package:oneship_customer/features/vendor_home/presentation/views/vendor_home_page.dart';
import 'package:oneship_customer/features/wallet/presentation/views/wallet_page.dart';

enum BottomNavigationItem {
  home,
  vendorHome,
  orderList,
  createOrder,
  finance,
  wallet,
  menu,
}

extension BottomNavigationItemExt on BottomNavigationItem {
  static const _mapTitle = {
    BottomNavigationItem.home: 'Trang chủ',
    BottomNavigationItem.vendorHome: 'Trang chủ',
    BottomNavigationItem.orderList: 'Đơn hàng',
    BottomNavigationItem.createOrder: '',
    BottomNavigationItem.finance: 'Thống kê',
    BottomNavigationItem.wallet: 'Ví',
    BottomNavigationItem.menu: 'Menu',
  };

  static const _mapIcon = {
    BottomNavigationItem.home: SvgPath.iconHome,
    BottomNavigationItem.vendorHome: SvgPath.iconHome,
    BottomNavigationItem.orderList: SvgPath.iconOrderList,
    BottomNavigationItem.createOrder: SvgPath.iconAdd,
    BottomNavigationItem.finance: SvgPath.iconFinance,
    BottomNavigationItem.wallet: SvgPath
        .wallet, // Ensure this exists, or use a default one like SvgPath.iconWallet
    BottomNavigationItem.menu: SvgPath.iconMenu,
  };

  static const _mapPage = {
    BottomNavigationItem.home: ShopHome(),
    BottomNavigationItem.vendorHome: VendorHomePage(),
    BottomNavigationItem.orderList: OrdersPage(),
    BottomNavigationItem.createOrder: CreateOrderPage(),
    BottomNavigationItem.finance: FinancePage(),
    BottomNavigationItem.wallet: WalletPage(),
    // BottomNavigationItem.staffManagement: ShopStaffManagementPage(),
    // BottomNavigationItem.shopManagement: ShopManagementPage(),
    BottomNavigationItem.menu: GeneralProfilePage(),
  };

  String get title => _mapTitle[this]!;

  String get icon => _mapIcon[this]!;

  Widget get page => _mapPage[this]!;
}
