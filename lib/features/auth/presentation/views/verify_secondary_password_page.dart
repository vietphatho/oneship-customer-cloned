import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/auth/presentation/widgets/forgot_secondary_password_dialog.dart';

class VerifySecondaryPasswordPage extends StatefulWidget {
  const VerifySecondaryPasswordPage({super.key, required this.onCallback});

  final VoidCallback onCallback;

  @override
  State<VerifySecondaryPasswordPage> createState() =>
      _VerifySecondaryPasswordPageState();
}

class _VerifySecondaryPasswordPageState
    extends State<VerifySecondaryPasswordPage> {
  final AuthBloc _authBloc = getIt.get();
  final TextEditingController _secondPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _secondPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgotSecondaryPasswordListener(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (context, state) {
              if (_authBloc.userProfile.hasSecondPassword == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      'security_verification'.tr(),
                      style: AppTextStyles.titleXXXLarge,
                    ),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                    PrimaryText(
                      'enter_secondary_password'.tr(),
                      style: AppTextStyles.labelLarge,
                    ),
                    AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                    PrimaryTextField(
                      label: 'second_password'.tr(),
                      obscureText: true,
                      controller: _secondPasswordCtrl,
                    ),
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    BlocListener<AuthBloc, AuthState>(
                      bloc: _authBloc,
                      listener: _handleVerifySecondPasswordListener,
                      child: PrimaryButton.filled(
                        label: 'confirm'.tr(),
                        onPressed: () {
                          if (_secondPasswordCtrl.text.isNotEmpty) {
                            _authBloc.verifySecondaryPassword(
                              secondPassword: _secondPasswordCtrl.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                    PrimaryTextButton(
                      label: 'forgot_secondary_password'.tr(),
                      onPressed: () =>
                          ForgotSecondaryPasswordDialog.show(context),
                    ),
                    PrimaryText(
                      'information_completely_secure'.tr(),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryText(
                    'create_second_password'.tr(),
                    style: AppTextStyles.titleXXLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  PrimaryText(
                    'need_to_create_secondary_password'.tr(),
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                  PrimaryButton.filled(
                    label: 'create_second_password'.tr(),
                    onPressed: () async {
                      final isCreated = await context.push<bool>(
                        RouteName.changeSecondaryPasswordPage,
                      );
                      if (isCreated == true) {
                        widget.onCallback();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleVerifySecondPasswordListener(
    BuildContext context,
    AuthState state,
  ) {
    if (state is AuthVerifySecondaryPasswordState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          widget.onCallback();
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
