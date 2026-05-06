import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/navigation/app_navigator.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/navigation/route_observer_page.dart';
import 'package:oneship_customer/features/auth/presentation/views/login_page.dart';
import 'package:oneship_customer/features/auth/presentation/views/register_page.dart';
import 'package:oneship_customer/features/auth/presentation/views/verify_email_page.dart';
import 'package:oneship_customer/features/home/presentation/view/home_page.dart';
import 'package:oneship_customer/features/order_tracking/presentation/view/order_tracking_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_multi_orders_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/create_order_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_detail_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/orders_page.dart';
import 'package:oneship_customer/features/packages/presentation/views/package_detail_page.dart';
import 'package:oneship_customer/features/packages/presentation/views/packages_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/create_shop_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_empty_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_pending_approval_page.dart';
import 'package:oneship_customer/features/profile/presentation/views/profile_detail_page.dart';
import 'package:oneship_customer/features/shop_master/presentation/views/shop_master_page.dart';
import 'package:oneship_customer/features/splash/presentation/views/splash_page.dart';
import 'package:oneship_customer/features/orders/presentation/views/orders_history_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: AppNavigator.globalKey,
  initialLocation: RouteName.splashPage,
  observers: [RouteObserverPage()],
  routes: [
    GoRoute(
      path: RouteName.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteName.homePage,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouteName.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteName.registerPage,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteName.verifyEmailPage,
      builder: (context, state) => VerifyEmailPage(),
    ),
    GoRoute(
      path: RouteName.shopMasterPage,
      builder: (context, state) => const ShopMasterPage(),
    ),
    GoRoute(
      path: RouteName.shopEmptyPage,
      builder: (context, state) => const ShopEmptyPage(),
    ),
    GoRoute(
      path: RouteName.createShopPage,
      builder: (context, state) => const CreateShopPage(),
    ),
    GoRoute(
      path: RouteName.shopPendingApprovalPage,
      builder: (context, state) => const ShopPendingApprovalPage(),
    ),
    GoRoute(
      path: RouteName.createOrderPage,
      builder: (context, state) => const CreateOrderPage(),
    ),
    GoRoute(
      path: RouteName.ordersPage,
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: RouteName.orderDetailPage,
      builder: (context, state) => const OrderDetailPage(),
    ),
    GoRoute(
      path: RouteName.packagesPage,
      builder: (context, state) => const PackagesPage(),
    ),
    GoRoute(
      path: RouteName.packageDetailPage,
      builder: (context, state) => const PackageDetailPage(),
    ),
    GoRoute(
      path: RouteName.orderTrackingPage,
      builder: (context, state) => const OrderTrackingPage(),
    ),
    GoRoute(
      path: RouteName.createMultiOrdersPage,
      builder: (context, state) => const CreateMultiOrdersPage(),
    ),
    GoRoute(
      path: RouteName.profileDetailPage,
      builder: (context, state) => const ProfileDetailPage(),
    ),
    GoRoute(
      path: RouteName.ordersHistoryPage,
      builder: (context, state) => const OrdersHistoryPage(),
    ),
  ],
);
