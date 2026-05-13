import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_password_request.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final AuthBloc _authBloc = getIt.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPwdCtrl = TextEditingController();
  final TextEditingController _secondaryPwdCtrl = TextEditingController();
  final TextEditingController _newPwdCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPwdCtrl.dispose();
    _secondaryPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'change_password.page_title'.tr(),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleUpdatePasswordListener,
        child: Padding(
          padding: AppDimensions.mediumPaddingHorizontal,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppSpacing.vertical(AppDimensions.largeSpacing),
                PrimaryTextField(
                  label: 'change_password.current_password'.tr(),
                  isRequired: true,
                  controller: _currentPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: Validators.validateEmptyField,
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryTextField(
                  label: 'change_password.secondary_password'.tr(),
                  isRequired: true,
                  controller: _secondaryPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: Validators.validateEmptyField,
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryTextField(
                  label: 'change_password.new_password'.tr(),
                  isRequired: true,
                  controller: _newPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: Validators.validateEmptyField,
                ),
                const Spacer(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.mediumSpacing),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton.outlined(
                            label: 'change_password.button_close'.tr(),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        AppSpacing.horizontal(AppDimensions.mediumSpacing),
                        Expanded(
                          child: SecondaryButton.filled(
                            label: 'change_password.button_update'.tr(),
                            onPressed: _onUpdatePressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onUpdatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdatePasswordRequest(
        currentPassword: _currentPwdCtrl.text.trim(),
        secondPassword: _secondaryPwdCtrl.text.trim(),
        newPassword: _newPwdCtrl.text.trim(),
      );
      _authBloc.updatePassword(request);
    }
  }

  void _handleUpdatePasswordListener(BuildContext context, AuthState state) {
    if (state is AuthUpdatedPasswordState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          _authBloc.fetchUserProfile();
          PrimaryDialog.showSuccessDialog(
            context,
            message: 'account_info.update_success'.tr(),
            onClosed: () {
              if (mounted) Navigator.pop(context);
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
