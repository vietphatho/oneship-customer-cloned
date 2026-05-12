import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_text_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

class EmptyShopPage extends StatelessWidget {
  const EmptyShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = getIt.get();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: _handleLogOutListener,
          listenWhen: (_, state) => state is AuthLogOutState,
          child: const _Body(),
        ),
      ),
    );
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

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.getSize(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.smallSpacing,
        AppDimensions.mediumSpacing,
        0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height * 0.78),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(ImagePath.logo, width: size.width * 0.64),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryText(
                "no_shop_title".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineSmall,
              ),
              AppSpacing.vertical(AppDimensions.xLargeSpacing),
              PrimaryText(
                "no_shop_description".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
                color: AppColors.neutral5,
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              SizedBox(
                width: size.width * 0.48,
                height: size.width * 0.48,
                child: Image.asset(
                  ImagePath.shopOnboarding,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.storefront_outlined,
                        size: 120,
                        color: AppColors.primary,
                      ),
                ),
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryButton.iconFilled(
                label: "create_new_shop".tr(),
                onPressed: () {
                  context.push(RouteName.createShopPage);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: AppDimensions.smallIconSize,
                ),
              ),
              SecondaryTextButton(
                label: "back_to_log_in".tr(),
                padding: EdgeInsets.all(AppDimensions.largeSpacing),
                onPressed: _onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBack() {
    final AuthBloc authBloc = getIt.get();
    authBloc.logOut();
  }
}
