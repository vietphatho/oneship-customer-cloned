import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/secondary_text_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopPendingApprovalPage extends StatelessWidget {
  const ShopPendingApprovalPage({super.key});

  static const String _hotline = Constants.tpSwitchBoard;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.getSize(context);
    final shopBloc = getIt.get<ShopBloc>();
    final AuthBloc authBloc = getIt.get();

    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: _handleLogOutListener,
      listenWhen: (_, state) => state is AuthLogOutState,

      child: BlocBuilder<ShopBloc, ShopState>(
        bloc: shopBloc,
        buildWhen:
            (previous, current) =>
                previous.createShopResource != current.createShopResource,
        builder: (context, state) {
          final shopName = state.createShopResource.data?.shopName ?? '';

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.mediumSpacing,
                  AppDimensions.largeSpacing,
                  AppDimensions.mediumSpacing,
                  AppDimensions.largeSpacing,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        size.height -
                        MediaQuery.of(context).padding.vertical -
                        AppDimensions.xxxLargeSpacing * 2,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(ImagePath.logo, width: size.width * 0.48),
                          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                          PrimaryText(
                            shopName.isEmpty
                                ? "shop_name_placeholder".tr()
                                : shopName,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headlineSmall,
                            color: AppColors.primary,
                          ),
                          PrimaryText(
                            "pending_approval".tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge,
                          ),
                          AppSpacing.vertical(AppDimensions.xLargeSpacing),
                          PrimaryText(
                            "pending_approval_description".tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium,
                            color: AppColors.neutral5,
                          ),
                          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                          SizedBox(
                            width: size.width * 0.66,
                            height: size.width * 0.42,
                            child: Image.asset(
                              ImagePath.shopPendingApproval,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (_, __, ___) => const Icon(
                                    Icons.local_shipping_outlined,
                                    size: 120,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                          _SupportCard(
                            hotline: _hotline,
                            onCopy: () {
                              Clipboard.setData(
                                const ClipboardData(text: _hotline),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("hotline_copied".tr())),
                              );
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.smallSpacing),
                          SecondaryTextButton(
                            label: "back_to_log_in".tr(),
                            padding: EdgeInsets.all(AppDimensions.largeSpacing),
                            onPressed: _onBack,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onBack() {
    final AuthBloc authBloc = getIt.get();
    authBloc.logOut();
  }

  void _handleLogOutListener(BuildContext context, AuthState state) {
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
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.hotline, required this.onCopy});

  final String hotline;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PrimaryText(
            "contact_support".tr(),
            style: AppTextStyles.labelLarge,
            color: AppColors.primary,
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.phone, color: Colors.white, size: 22),
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              PrimaryText(
                hotline,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.largeSpacing),
          PrimaryText(
            "support_working_hours".tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral5,
          ),
        ],
      ),
    );
  }
}
