// ignore_for_file: constant_identifier_names

class RouteName {
  RouteName._internal();

  static const String splashPage = '/';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String verifyEmailPage = '/verify_email';
  static const String shopMasterPage = '/shop_master';
  static const String registerPage = '/register';

  static const String shopEmptyPage = '/shop_empty';
  static const String createShopPage = '/shop_master/create_shop';
  static const String createShopStaffPage = '/shop_master/create_shop_staff';
  static const String shopStaffDetailPage = '/shop_master/shop_staff_detail';
  static const String addShopToStaffPage = '/shop_master/add_shop_to_staff';
  static const String shopPendingApprovalPage = '/shop_pending_approval';

  static const String createOrderPage = '/shop_master/create_order';
  static const String createMultiOrdersPage =
      '/shop_master/create_multi_orders';
  static const String ordersPage = '/shop_master/orders';
  static const String orderDetailPage = '/shop_master/orders/order_detail';
  static const String packagesPage = '/shop_master/packages';
  static const String packageDetailPage =
      '/shop_master/packages/package_detail';

  static const String orderTrackingPage = '/home/order_tracking_page';

  static const String profileDetailPage = '/profile_detail';
  static const String ordersHistoryPage = '/shop_master/orders_history';
}
