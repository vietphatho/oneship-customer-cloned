import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_avatar.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/navigation/route_name.dart';
import 'package:oneship_shop/core/utils/function_utils.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_shop/features/auth/presentation/bloc/auth_state.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = getIt.get();
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: AppDimensions.mediumPaddingHorizontal,
          child: Column(
            children: [
              // HEADER
              Row(
                children: [
                  PrimaryAvatar(
                    url: authBloc.userProfile.avatarUrl,
                    radius: AppDimensions.customerAvatarRadius,
                    showStatusIndicator: false,
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText("hi".tr(), style: AppTextStyles.bodyMedium),
                      PrimaryText(
                        authBloc.userProfile.displayName,
                        style: AppTextStyles.titleLarge,
                      ),
                      PrimaryText(
                        authBloc.userProfile.userPhone,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),

              // MENU ITEMS
              Expanded(
                child: ListView(
                  children: [
                    _drawerItem(
                      icon: Icons.person,
                      label: 'delete_account'.tr(),
                      onTap: () {
                        PrimaryDialog.showAlertDialog(
                          context,
                          message: "contact_admin_to_delete_account".tr(),
                        );
                      },
                      color: AppColors.logout,
                    ),

                    // const Divider(),
                    BlocListener<AuthBloc, AuthState>(
                      bloc: authBloc,
                      listener: _handleLogoutStateListener,
                      child: _drawerItem(
                        icon: Icons.logout_outlined,
                        label: 'logout'.tr(),
                        onTap: () {
                          authBloc.logOut();
                        },
                        color: AppColors.logout,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogoutStateListener(BuildContext context, AuthState state) {
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
          PrimaryDialog.showErrorDialog(
            context,
            message: state.resource.message,
          );
          break;
      }
    }
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.onBackground),
      title: PrimaryText(
        label,
        style: AppTextStyles.bodyMedium,
        color: color ?? AppColors.onBackground,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
      ),
      onTap: onTap,
    );
  }
}
