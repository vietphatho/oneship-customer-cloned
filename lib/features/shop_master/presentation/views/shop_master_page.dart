// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:oneship_customer/core/base/base_import_components.dart';
// import 'package:oneship_customer/core/base/components/primary_dialog.dart';
// import 'package:oneship_customer/core/base/constants/enum.dart';
// import 'package:oneship_customer/core/navigation/route_name.dart';
// import 'package:oneship_customer/di/injection_container.dart';
// import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
// import 'package:oneship_customer/features/shop_master/data/enum.dart';
// import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
// import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';
// import 'package:oneship_customer/features/shop_master/presentation/widgets/shop_master_app_bar.dart';
// import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';
// import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_drawer.dart';

// class ShopMasterPage extends StatefulWidget {
//   const ShopMasterPage({super.key});

//   @override
//   State<ShopMasterPage> createState() => _ShopMasterPageState();
// }

// class _ShopMasterPageState extends State<ShopMasterPage> {
//   final ShopMasterBloc _shopMasterBloc = getIt.get();
//   final AuthBloc _authBloc = getIt.get();

//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: const PrimaryDrawer(),
//       body: BlocListener<AuthBloc, AuthState>(
//         bloc: _authBloc,
//         listener: _handleAuthListener,
//         child: BlocConsumer<ShopMasterBloc, ShopMasterState>(
//           bloc: _shopMasterBloc,
//           listener: _handleListener,
//           builder: (context, state) {
//             return Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Column(
//                   children: [
//                     const ShopMasterAppBar(),
//                     AppSpacing.vertical(AppDimensions.smallSpacing),
//                     Expanded(
//                       child: PageView.builder(
//                         controller: _pageController,
//                         itemCount: BottomNavigationItem.values.length,
//                         itemBuilder:
//                             (context, index) =>
//                                 BottomNavigationItem.values[index].page,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const PrimaryBottomNavigationBar(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _handleListener(BuildContext context, ShopMasterState state) {
//     if (state is ShopMasterMenuTabChangedState) {
//       _pageController.animateToPage(
//         _shopMasterBloc.currentTab.index,
//         duration: Constants.pageViewTransitionDur,
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _handleAuthListener(BuildContext context, AuthState state) {
//     if (state is AuthLogOutState) {
//       switch (state.resource.state) {
//         case Result.loading:
//           PrimaryDialog.showLoadingDialog(context);
//           break;
//         case Result.success:
//           PrimaryDialog.hideLoadingDialog(context);
//           context.pushReplacement(RouteName.loginPage);
//           break;
//         case Result.error:
//           PrimaryDialog.hideLoadingDialog(context);
//           PrimaryDialog.showErrorDialog(
//             context,
//             message: state.resource.message,
//           );
//           break;
//       }
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_bottom_navigation_bar.dart';
import 'package:oneship_customer/features/shop_master/presentation/widgets/primary_drawer.dart';

class ShopMasterPage extends StatefulWidget {
  const ShopMasterPage({super.key});

  @override
  State<ShopMasterPage> createState() => _ShopMasterPageState();
}

class _ShopMasterPageState extends State<ShopMasterPage> {
  final ShopMasterBloc _shopMasterBloc = getIt.get();
  final AuthBloc _authBloc = getIt.get();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const PrimaryDrawer(),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleAuthListener,
        child: BlocConsumer<ShopMasterBloc, ShopMasterState>(
          bloc: _shopMasterBloc,
          listener: _handleListener,
          builder: (context, state) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: BottomNavigationItem.values.length,
                        itemBuilder:
                            (context, index) =>
                                BottomNavigationItem.values[index].page,
                      ),
                    ),
                  ],
                ),
                const PrimaryBottomNavigationBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, ShopMasterState state) {
    if (state is ShopMasterMenuTabChangedState) {
      _pageController.animateToPage(
        _shopMasterBloc.currentTab.index,
        duration: Constants.pageViewTransitionDur,
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleAuthListener(BuildContext context, AuthState state) {
    if (state is AuthLogOutState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          context.pushReplacement(RouteName.loginPage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(
            context,
            message: state.resource.message,
          );
          break;
      }
    }
  }
}
