import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_button.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.mediumSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryText(
              'security_verification'.tr(),
              style: AppTextStyles.displaySmall,
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
              onPressed: () {},
            ),
            PrimaryText(
              'information_completely_secure'.tr(),
              style: AppTextStyles.bodySmall,
            ),
          ],
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
