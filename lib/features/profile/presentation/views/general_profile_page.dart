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
import 'package:oneship_customer/features/profile/presentation/widgets/general_profile_header.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/general_profile_info_section.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/general_profile_menu_section.dart';

class GeneralProfilePage extends StatefulWidget {
  const GeneralProfilePage({super.key});

  @override
  State<GeneralProfilePage> createState() => _GeneralProfilePageState();
}

class _GeneralProfilePageState extends State<GeneralProfilePage> {
  final AuthBloc _authBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _handleLogOutListener,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE8C7),
                Color(0xFFFFF5E8),
                Color(0xFFFFFBF6),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.18, 0.38, 0.62],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.largeSpacing,
                AppDimensions.largeSpacing,
                AppDimensions.largeSpacing,
                AppDimensions.safeBottomSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GeneralProfileTopBar(),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  const GeneralProfileSummaryCard(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const GeneralProfileShopInfoCard(),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  const GeneralProfileMenuPanel(),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  GeneralProfileLogoutButton(authBloc: _authBloc),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  Center(
                    child: PrimaryText(
                      'Phiên bản 2.1.0',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                      color: AppColors.neutral5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogOutListener(context, state) {
    if (state is AuthLogOutState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          FunctionUtils.handleAfterLogout();
          context.go(RouteName.homePage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }
}
