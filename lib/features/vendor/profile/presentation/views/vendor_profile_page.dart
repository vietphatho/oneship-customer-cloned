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
import 'package:oneship_customer/features/profile/presentation/widgets/app_version.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/widgets/vendor_profile_header.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/widgets/vendor_profile_menu_section.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  final AuthBloc _authBloc = getIt.get();
  final VendorProfileBloc _vendorProfileBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorProfileBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _handleAuthListener,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.shopHomeV2HeaderBackground,
                AppColors.shopHomeV2SoftOrangeBackground,
                AppColors.background,
                AppColors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.18, 0.38, 0.62],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.smallSpacing,
                AppDimensions.smallSpacing,
                AppDimensions.smallSpacing,
                150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VendorProfileTopBar(),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  const VendorProfileSummaryCard(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const VendorProfileInfoCard(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const VendorProfileMenuPanel(),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  const VendorProfileLogoutButton(),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  const Center(child: AppVersion()),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthListener(BuildContext context, AuthState state) {
    if (state is AuthLogOutState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          _vendorProfileBloc.clear();
          FunctionUtils.handleAfterLogout();
          context.go(RouteName.homePage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(
            context,
            message: state.resource.message,
          );
          break;
      }
    } else if (state is AuthDeleteAccountState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          _vendorProfileBloc.clear();
          PrimaryDialog.showSuccessDialog(
            context,
            message: 'account_deleted'.tr(),
            onClosed: () => context.go(RouteName.homePage),
          );
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
