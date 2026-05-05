import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_empty_page.dart';
import 'package:oneship_customer/features/shop_home/presentation/views/shop_pending_approval_page.dart';
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
  final ShopBloc _shopBloc = getIt.get();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _handleAuthListener,
      child: BlocBuilder<ShopBloc, ShopState>(
        bloc: _shopBloc,
        buildWhen:
            (previous, current) =>
                previous.shopsResource != current.shopsResource ||
                previous.currentShop != current.currentShop,
        builder: (context, shopState) {
          final onboardingPage = _buildOnboardingPage(shopState);
          if (onboardingPage != null) {
            return onboardingPage;
          }

          return _buildApprovedShopPage();
        },
      ),
    );
  }

  Widget _buildApprovedShopPage() {
    return Scaffold(
      endDrawer: const PrimaryDrawer(),
      body: BlocConsumer<ShopMasterBloc, ShopMasterState>(
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
    );
  }

  Widget? _buildOnboardingPage(ShopState state) {
    if (state.shopsResource.state == Result.loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final shops = state.shopsResource.data?.data ?? const [];
    if (shops.isEmpty) {
      return const ShopEmptyPage(); // Trang 1: Chưa có shop
    }

    // Tìm xem có shop nào đã được duyệt chưa (status == 'active')
    final hasApprovedShop = shops.any(
      (shop) => shop.shopStatus?.trim().toLowerCase() == 'active',
    );

    // Nếu chưa có shop nào được duyệt (tức là tất cả đều đang pending)
    if (!hasApprovedShop) {
      return const ShopPendingApprovalPage(); // Trang 2: Đang chờ duyệt
    }

    return null; // Trang 3: Đã có shop duyệt -> Return null để build ApprovedShopPage
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
