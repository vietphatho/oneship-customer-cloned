import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/app_routes.dart';
import 'package:oneship_customer/core/navigation/route_observer_page.dart';
import 'package:oneship_customer/core/network/network_utils.dart';
import 'package:oneship_customer/core/themes/app_theme.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';

class OneShipCustomerApp extends StatelessWidget {
  const OneShipCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('vi')],
      path: 'assets/langs',
      fallbackLocale: const Locale('vi'),
      child: const _OneShipCustomerMaterialApp(),
    );
  }
}

class _OneShipCustomerMaterialApp extends StatefulWidget {
  const _OneShipCustomerMaterialApp();

  @override
  State<_OneShipCustomerMaterialApp> createState() =>
      _OneShipCustomerMaterialAppState();
}

class _OneShipCustomerMaterialAppState
    extends State<_OneShipCustomerMaterialApp> {
  final _routeObserver = RouteObserverPage();
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    NetworkUtils.listen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: appRouter,
          color: AppColors.primary,
          // onGenerateRoute: AppRoutes.generateRoutes,
          // navigatorKey: AppNavigator.globalKey,
          // navigatorObservers: [_routeObserver],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // themeMode: _splashBloc.themeMode,
          // scrollBehavior: AppScrollBehavior(),
        ),
      ),
    );
  }
}
