import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_second_password_request.dart';

class ChangeSecondaryPasswordPage extends StatefulWidget {
  const ChangeSecondaryPasswordPage({super.key});

  @override
  State<ChangeSecondaryPasswordPage> createState() => _ChangeSecondaryPasswordPageState();
}

class _ChangeSecondaryPasswordPageState extends State<ChangeSecondaryPasswordPage> {
  final AuthBloc _authBloc = getIt.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPwdCtrl = TextEditingController();
  final TextEditingController _currentSecondaryPwdCtrl = TextEditingController();
  final TextEditingController _newSecondaryPwdCtrl = TextEditingController();
  final TextEditingController _confirmNewSecondaryPwdCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPwdCtrl.dispose();
    _currentSecondaryPwdCtrl.dispose();
    _newSecondaryPwdCtrl.dispose();
    _confirmNewSecondaryPwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = _authBloc.userProfile;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: (userProfile.hasSecondPassword ?? false)
            ? 'secondary_password.change_page_title'.tr()
            : 'secondary_password.create_page_title'.tr(),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleUpdatePasswordListener,
        child: Padding(
          padding: AppDimensions.mediumPaddingHorizontal,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.vertical(AppDimensions.largeSpacing),
                PrimaryTextField(
                  label: 'secondary_password.current_password'.tr(),
                  isRequired: true,
                  controller: _currentPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: Validators.validateEmptyField,
                ),
                if (userProfile.hasSecondPassword ?? false) ...[
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  PrimaryTextField(
                    label: 'secondary_password.current_secondary_password'.tr(),
                    isRequired: true,
                    controller: _currentSecondaryPwdCtrl,
                    hintText: 'input'.tr(),
                    obscureText: true,
                    validator: Validators.validateEmptyField,
                  ),
                ],
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryTextField(
                  label: 'secondary_password.new_password'.tr(),
                  isRequired: true,
                  controller: _newSecondaryPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: Validators.validateEmptyField,
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryTextField(
                  label: 'secondary_password.confirm_new_password'.tr(),
                  isRequired: true,
                  controller: _confirmNewSecondaryPwdCtrl,
                  hintText: 'input'.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "validate.text_required".tr();
                    }
                    if (value != _newSecondaryPwdCtrl.text) {
                      return "password_not_match".tr();
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.mediumSpacing),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton.filled(
                            label: 'secondary_password.button_update'.tr(),
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
      final hasSecondPassword = _authBloc.userProfile.hasSecondPassword ?? false;

      if (hasSecondPassword) {
        final request = UpdateSecondPasswordRequest(
          currentPassword: _currentPwdCtrl.text.trim(),
          currentSecondPassword: _currentSecondaryPwdCtrl.text.trim(),
          newSecondPassword: _newSecondaryPwdCtrl.text.trim(),
        );
        _authBloc.updatePassword(
          request,
          updateType: AuthUpdatePasswordType.updateSecondary,
        );
      } else {
        final request = CreateSecondPasswordRequest(
          currentPassword: _currentPwdCtrl.text.trim(),
          secondPassword: _newSecondaryPwdCtrl.text.trim(),
        );
        _authBloc.updatePassword(
          request,
          updateType: AuthUpdatePasswordType.createSecondary,
        );
      }
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
