import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/function_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_bloc.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_state.dart';
import 'package:oneship_customer/features/vendor/master/presentation/widgets/vendor_bottom_navigation_bar.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';

class VendorMasterPage extends StatefulWidget {
  const VendorMasterPage({super.key});

  @override
  State<VendorMasterPage> createState() => _VendorMasterPageState();
}

class _VendorMasterPageState extends State<VendorMasterPage> {
  final VendorMasterBloc _vendorMasterBloc = getIt.get();
  final AuthBloc _authBloc = getIt.get();
  final VendorProfileBloc _vendorProfileBloc = getIt.get();
  final VendorStatsBloc _vendorStatsBloc = getIt.get();

  late final PageController _pageController;

  static const _tabs = [
    VendorNavigationItem.home,
    VendorNavigationItem.orders,
    VendorNavigationItem.finance,
    VendorNavigationItem.profile,
  ];

  @override
  void initState() {
    super.initState();
    _vendorProfileBloc.init();
    _pageController = PageController(
      initialPage: _tabs.indexOf(_vendorMasterBloc.currentTab),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleAuthListener,
        child: BlocConsumer<VendorMasterBloc, VendorMasterState>(
          bloc: _vendorMasterBloc,
          listener: _handleListener,
          builder: (context, state) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) => _tabs[index].page,
                ),
                const VendorBottomNavigationBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, VendorMasterState state) {
    if (state is VendorMasterMenuTabChangedState) {
      _pageController.jumpToPage(_tabs.indexOf(_vendorMasterBloc.currentTab));
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
          _vendorStatsBloc.clear();
          _vendorProfileBloc.clear();
          FunctionUtils.handleAfterLogout();
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
