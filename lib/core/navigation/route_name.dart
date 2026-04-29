// ignore_for_file: constant_identifier_names

class RouteName {
  RouteName._internal();

  static const String splashPage = '/';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String registerPage = '/register';

  static const String shopMasterPage = '/shop_master';
  static const String shopPendingApprovalPage =
      '/shop_master/shop_pending_approval';
  static const String createOrderPage = '/shop_master/create_order';
  static const String createMultiOrdersPage =
      '/shop_master/create_multi_orders';
  static const String ordersPage = '/shop_master/orders';
  static const String orderDetailPage = '/shop_master/orders/order_detail';
  static const String packagesPage = '/shop_master/packages';
  static const String packageDetailPage =
      '/shop_master/packages/package_detail';

  static const String orderTrackingPage = '/home/order_tracking_page';
}
