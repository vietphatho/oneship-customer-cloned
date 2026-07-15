import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorProfileMenuPanel extends StatelessWidget {
  const VendorProfileMenuPanel({super.key});

  List<PrimaryMenuItemData> _items(
    BuildContext context, {
    required bool hasSecondPassword,
  }) {
    return [
      PrimaryMenuItemData(
        icon: Icons.person_outline_rounded,
        iconColor: AppColors.primary,
        label: 'vendor_profile.menu.profile_info'.tr(),
        onTap: () => context.push(RouteName.vendorProfileDetailPage),
      ),
      PrimaryMenuItemData(
        icon: Icons.lock_outline_rounded,
        iconColor: AppColors.info,
        label: 'vendor_profile.menu.change_password'.tr(),
        onTap: () => context.push(RouteName.changePasswordPage),
      ),
      PrimaryMenuItemData(
        icon: Icons.enhanced_encryption_outlined,
        iconColor: AppColors.investmentPurple,
        label: hasSecondPassword
            ? 'profile_menu.change_second_password'.tr()
            : 'profile_menu.create_second_password'.tr(),
        onTap: () => context.push(RouteName.changeSecondaryPasswordPage),
      ),
      PrimaryMenuItemData(
        icon: Icons.location_on_outlined,
        iconColor: AppColors.green,
        label: 'vendor_profile.menu.pickup_address'.tr(),
      ),
      PrimaryMenuItemData(
        icon: Icons.credit_card_rounded,
        iconColor: AppColors.primary,
        label: 'vendor_profile.menu.payment_method'.tr(),
      ),
      PrimaryMenuItemData(
        icon: Icons.notifications_none_rounded,
        iconColor: AppColors.error,
        label: 'vendor_profile.menu.notification'.tr(),
      ),
      PrimaryMenuItemData(
        icon: Icons.language_rounded,
        iconColor: AppColors.investmentPurple,
        label: 'vendor_profile.menu.language'.tr(),
        trailingText: 'vendor_profile.menu.language_value'.tr(),
      ),
      PrimaryMenuItemData(
        icon: Icons.support_agent_rounded,
        iconColor: AppColors.info,
        label: 'vendor_profile.menu.support_center'.tr(),
        onTap: () async {
          final uri = Uri(scheme: 'mailto', path: Constants.oneshipGmail);

          if (!await launchUrl(uri)) {
            throw Exception('Could not launch email app');
          }
        },
      ),
      PrimaryMenuItemData(
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.primary,
        label: 'vendor_profile.menu.about'.tr(),
        onTap: () async {
          final uri = Uri.parse(Constants.oneshipWebsite);
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        },
      ),
      PrimaryMenuItemData(
        icon: Icons.account_circle_rounded,
        iconColor: AppColors.red500,
        label: 'delete_account'.tr(),
        onTap: () {
          PrimaryDialog.showQuestionDialog(
            context,
            message: 'do_you_want_to_delete_account'.tr(),
            onPositiveTapped: () => getIt.get<AuthBloc>().deleteAccount(),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      buildWhen: (previous, current) =>
          current is AuthFetchedUserProfileState ||
          current is AuthUpdatedPasswordState,
      builder: (context, state) {
        final items = _items(
          context,
          hasSecondPassword: authBloc.userProfile.hasSecondPassword ?? false,
        );

        return PrimaryPanel(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                PrimaryMenuItem(
                  data: items[i],
                  showDivider: i != items.length - 1,
                ),
            ],
          ),
        );
      },
    );
  }
}

class VendorProfileLogoutButton extends StatelessWidget {
  const VendorProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: 'vendor_profile.logout'.tr(),
      type: PrimaryActionButtonType.dangerOutlined,
      width: double.infinity,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () {
        PrimaryDialog.showQuestionDialog(
          context,
          title: 'confirm_logout'.tr(),
          onPositiveTapped: getIt.get<AuthBloc>().logOut,
        );
      },
    );
  }
}
