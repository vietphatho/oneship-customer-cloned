import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/function_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/app_version.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_background_scaffold.dart';

class GeneralProfilePage extends StatefulWidget {
  const GeneralProfilePage({super.key});

  @override
  State<GeneralProfilePage> createState() => _GeneralProfilePageState();
}

class _GeneralProfilePageState extends State<GeneralProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ProfileBackgroundScaffold(
      showBodyBackground: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppDimensions.mediumPaddingAll,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                _SettingsContainer(),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                // _UtilitiesContainer(),
                // AppSpacing.vertical(AppDimensions.mediumSpacing),
                _SupportsContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportsContainer extends StatelessWidget {
  final AuthBloc _authBloc = getIt.get();
  _SupportsContainer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileTitleItem(icon: SvgPath.iconHelper, label: "help".tr()),
        _ProfileSelectedItem(label: 'info'.tr(), onTap: () {}),
        Divider(height: 1, color: AppColors.neutral7),
        _ProfileSelectedItem(label: 'support_request'.tr(), onTap: () {}),
        Divider(height: 1, color: AppColors.neutral7),

        _ProfileSelectedItem(
          label: 'delete_account'.tr(),
          textColor: AppColors.expenseRed,
          onTap: () {
            PrimaryDialog.showQuestionDialog(
              context,
              message: "do_you_want_to_delete_account".tr(),
              onPositiveTapped: _authBloc.deleteAccount,
            );
          },
        ),
        Divider(height: 1, color: AppColors.neutral7),
        BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: _handleLogOutListener,
          child: _ProfileSelectedItem(
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
            textColor: AppColors.expenseRed,
          ),
        ),

        Divider(height: 1, color: AppColors.neutral7),
        const AppVersion(),
        AppSpacing.vertical(AppDimensions.largeSpacing),
      ],
    );
  }

  void _handleLogOutListener(BuildContext context, state) {
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
    } else if (state is AuthDeleteAccountState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showSuccessDialog(
            context,
            message: "account_deleted".tr(),
            onClosed: () {
              context.go(RouteName.homePage);
            },
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

class _UtilitiesContainer extends StatelessWidget {
  const _UtilitiesContainer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileTitleItem(icon: SvgPath.iconUtilities, label: "utilities".tr()),
        _ProfileSelectedItem(label: 'print_warning_label'.tr(), onTap: () {}),
        Divider(height: 1, color: AppColors.neutral7),
        _ProfileSelectedItem(label: 'create_api_key'.tr(), onTap: () {}),
      ],
    );
  }
}

class _SettingsContainer extends StatelessWidget {
  const _SettingsContainer();

  @override
  Widget build(BuildContext context) {
    final userProfile = getIt.get<AuthBloc>().userProfile;
    return Column(
      children: [
        _ProfileTitleItem(icon: SvgPath.iconSettings, label: "settings".tr()),
        _ProfileSelectedItem(
          label: 'account_info.page_title'.tr(),
          onTap: () {
            context.push(RouteName.profileDetailPage);
          },
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _ProfileSelectedItem(
          label: 'change_password.page_title'.tr(),
          onTap: () {
            context.push(RouteName.changePasswordPage);
          },
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _ProfileSelectedItem(
          label: (userProfile.hasSecondPassword ?? false)
              ? 'secondary_password.change_page_title'.tr()
              : 'secondary_password.create_page_title'.tr(),
          onTap: () {
            context.push(RouteName.changeSecondaryPasswordPage);
          },
        ),
        Divider(height: 1, color: AppColors.neutral7),
        _ProfileSelectedItem(label: 'activity_history'.tr(), onTap: () {}),
      ],
    );
  }
}

class _ProfileTitleItem extends StatelessWidget {
  final String icon;
  final String label;

  const _ProfileTitleItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: AppDimensions.smallIconSize),
        AppSpacing.horizontal(AppDimensions.smallSpacing),
        PrimaryText(
          label,
          style: AppTextStyles.titleXLarge,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _ProfileSelectedItem extends StatelessWidget {
  const _ProfileSelectedItem({
    required this.onTap,
    required this.label,
    this.textColor,
  });
  final VoidCallback onTap;
  final String label;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppDimensions.getSize(context).width,
        padding: AppDimensions.smallPaddingVertical,
        child: PrimaryText(
          label,
          style: AppTextStyles.labelMedium,
          color: textColor,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
              const _ProfileAvatar(),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    userProfile.displayName,
                    style: AppTextStyles.titleXXXLarge,
                  ),
                  PrimaryText(
                    userProfile.userPhone,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: AppDimensions.xxSmallPaddingAll,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                child: PrimaryText(
                  "active".tr(),
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return const PrimaryAssetAvatar(
      image: ImagePath.profileAvatarUser,
      backgroundImage: ImagePath.profileAvatarBackground,
      imageSize: AppDimensions.defaultAvatarRadius * 1.45,
      overlayImage: ImagePath.profileEditBadge,
      radius: AppDimensions.defaultAvatarRadius,
    );
  }
}
