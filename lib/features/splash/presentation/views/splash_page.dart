import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:oneship_customer/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _splashBloc = getIt<SplashBloc>();
  final ShopBloc _shopBloc = getIt.get();
  final AuthBloc _authBloc = getIt.get();
  final OrdersBloc _ordersBloc = getIt.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      bloc: _splashBloc,
      listener: _handleListener,
      child: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleAuthBlocListener,
        child: Scaffold(
          body: Container(
            color: AppColors.primary,
            child: Center(
              // child: Image.asset(
              //   ImagePath.logo,
              //   width: 250,
              //   height: 250,
              //   fit: BoxFit.contain,
              //   color: Colors.white,
              // ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, SplashState state) {
    if (state.hasLoginSession.data == false) {
      context.pushReplacement(RouteName.homePage);
    } else {
      _authBloc.fetchUserProfile();
    }
  }

  void _handleAuthBlocListener(BuildContext context, AuthState state) {
    if (state is AuthFetchedUserProfileState) {
      switch (state.resource.state) {
        case Result.loading:
          break;
        case Result.success:
          _shopBloc.init(state.resource.data?.id ?? "");
          // _ordersBloc.init(_managementBloc.currentShop?.shopId ?? "");
          context.pushReplacement(RouteName.shopMasterPage);
          break;
        case Result.error:
          context.pushReplacement(RouteName.homePage);
          break;
      }
    }
  }
}
