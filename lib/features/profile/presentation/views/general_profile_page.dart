import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

class GeneralProfilePage extends StatefulWidget {
  const GeneralProfilePage({super.key});

  @override
  State<GeneralProfilePage> createState() => _GeneralProfilePageState();
}

class _GeneralProfilePageState extends State<GeneralProfilePage> {
  final AuthBloc _authBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: AppDimensions.mediumPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              _settingsContainer(context),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _utilitiesContainer(context),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _supportsContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsContainer(BuildContext context) {
    return Column(
      children: [
        _profileTitleItem(icon: SvgPath.iconSettings, label: "settings".tr()),
        _profileSelectedItem(
          context,
          label: 'account_info'.tr(),
          onTap: () {
            context.push(RouteName.profileDetailPage);
          },
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _profileSelectedItem(
          context,
          label: 'change_password'.tr(),
          onTap: () {},
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _profileSelectedItem(
          context,
          label: 'change_secondary_password'.tr(),
          onTap: () {},
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _profileSelectedItem(
          context,
          label: 'activity_history'.tr(),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _utilitiesContainer(BuildContext context) {
    return Column(
      children: [
        _profileTitleItem(icon: SvgPath.iconUtilities, label: "utilities".tr()),
        _profileSelectedItem(
          context,
          label: 'print_warning_label'.tr(),
          onTap: () {},
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _profileSelectedItem(
          context,
          label: 'create_api_key'.tr(),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _supportsContainer(BuildContext context) {
    return Column(
      children: [
        _profileTitleItem(icon: SvgPath.iconHelper, label: "help".tr()),
        _profileSelectedItem(context, label: 'info'.tr(), onTap: () {}),
        Divider(height: 1, color: AppColors.neutral7),
        _profileSelectedItem(
          context,
          label: 'support_request'.tr(),
          onTap: () {},
        ),
        Divider(height: 1, color: AppColors.neutral7),
        BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: _handleLogOutListener,
          child: _profileSelectedItem(
            context,
            label: 'logout'.tr(),
            onTap: () {
              PrimaryDialog.showQuestionDialog(
                context,
                title: 'confirm_logout',
                onPositiveTapped: () {
                  _authBloc.logOut();
                },
              );
            },
            color: AppColors.expenseRed,
          ),
        ),
      ],
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
          context.pushReplacement(RouteName.loginPage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }

  Widget _profileTitleItem({required String icon, required String label}) {
    return Row(
      children: [
        // Icon(icon, color: AppColors.primary),
        SvgPicture.asset(icon, height: AppDimensions.smallIconSize),
        AppSpacing.horizontal(AppDimensions.xSmallSpacing),
        PrimaryText(
          label,
          style: AppTextStyles.titleXXLarge,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _profileSelectedItem(
    BuildContext context, {
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppDimensions.getSize(context).width,
        padding: AppDimensions.smallPaddingVertical,
        child: PrimaryText(
          label,
          style: AppTextStyles.labelLarge,
          color: color,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = getIt.get();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
        var userProfile = _authBloc.userProfile;

        return PrimaryCard(
          child: Row(
            children: [
              CircleAvatar(radius: AppDimensions.defaultAvatarRadius),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    userProfile.displayName,
                    style: AppTextStyles.displaySmall,
                  ),
                  PrimaryText(
                    userProfile.userPhone,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              const Spacer(),
              Container(
                padding: AppDimensions.xxSmallPaddingAll,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                child: PrimaryText(
                  "online".tr(),
                  style: AppTextStyles.bodySmall,
                  color: AppColors.green600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
