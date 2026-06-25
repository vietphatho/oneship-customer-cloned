// ignore_for_file: constant_identifier_names

class RouteName {
  RouteName._internal();

  static const String splashPage = '/';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String verifyEmailPage = '/verify_email';
  static const String shopMasterPage = '/shop_master';
  static const String customerHomePage = '/customer_home';
  static const String registerPage = '/register';

  static const String shopEmptyPage = '/shop_empty';
  static const String createShopPage = '/shop_master/create_shop';
  static const String createShopFromManagementPage =
      '/shop_master/create_shop_from_management';
  static const String createShopStaffPage = '/shop_master/create_shop_staff';
  static const String shopStaffDetailPage = '/shop_master/shop_staff_detail';
  static const String addShopToStaffPage = '/shop_master/add_shop_to_staff';
  static const String shopPendingApprovalPage = '/shop_pending_approval';
  static const String shopSelectionPage = '/shop_selection_page';

  static const String createOrderPage = '/shop_master/create_order';
  static const String deliveryServiceDetailPage =
      '/shop_master/create_order/delivery_service_detail';
  static const String surchargeDetailPage =
      '/shop_master/create_order/surcharge_detail';
  static const String createMultiOrdersPage =
      '/shop_master/create_multi_orders';
  static const String ordersPage = '/shop_master/orders';
  static const String orderDetailPage = '/shop_master/orders/order_detail';
  static const String packagesPage = '/shop_master/packages';
  static const String packageDetailPage =
      '/shop_master/packages/package_detail';

  static const String orderTrackingPage = '/home/order_tracking_page';
  static const String productPage = '/product_page';

  static const String financeDetailByDayPage = '/finance_detail_by_day';
  static const String financePeriodDetailPage = '/finance_period_detail_page';

  static const String profileDetailPage = '/profile_detail';
  static const String changePasswordPage = '/change_password';
  static const String changeSecondaryPasswordPage =
      '/change_secondary_password';
  static const String ordersHistoryPage = '/shop_master/orders_history';
  static const String supportPage = '/support';
  static const String supportCategoryPage = '/support/category';
  static const String complaintPage = '/complaints';
  static const String createComplaintPage = '/complaints/create';
  static const String complaintDetailPage = '/complaints/detail';

  static const String staffManagementPage = '/staff_management_page';
  static const String shopManagementPage = '/shop_management_page';

  static const String walletPage = '/wallet';
  static const String withdrawSuccessPage = '/wallet/withdraw_success';
  static const String scanPatientCodePage = '/scan_patient_code_page';
}
