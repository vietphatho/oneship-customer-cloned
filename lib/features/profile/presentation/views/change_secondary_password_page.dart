import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/models/request/create_second_password_request.dart';
import 'package:oneship_customer/features/auth/data/models/request/update_second_password_request.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_background_scaffold.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_form_scroll_view.dart';

class ChangeSecondaryPasswordPage extends StatefulWidget {
  const ChangeSecondaryPasswordPage({super.key});

  @override
  State<ChangeSecondaryPasswordPage> createState() =>
      _ChangeSecondaryPasswordPageState();
}

class _ChangeSecondaryPasswordPageState
    extends State<ChangeSecondaryPasswordPage> {
  final AuthBloc _authBloc = getIt.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPwdCtrl = TextEditingController();
  final TextEditingController _currentSecondaryPwdCtrl =
      TextEditingController();
  final TextEditingController _newSecondaryPwdCtrl = TextEditingController();
  final TextEditingController _confirmNewSecondaryPwdCtrl =
      TextEditingController();
  final FocusNode _currentPwdNode = FocusNode();
  final FocusNode _currentSecondaryPwdNode = FocusNode();
  final FocusNode _newSecondaryPwdNode = FocusNode();
  final FocusNode _confirmNewSecondaryPwdNode = FocusNode();

  @override
  void dispose() {
    _currentPwdCtrl.dispose();
    _currentSecondaryPwdCtrl.dispose();
    _newSecondaryPwdCtrl.dispose();
    _confirmNewSecondaryPwdCtrl.dispose();
    _currentPwdNode.dispose();
    _currentSecondaryPwdNode.dispose();
    _newSecondaryPwdNode.dispose();
    _confirmNewSecondaryPwdNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = _authBloc.userProfile;
    final hasSecondPassword = userProfile.hasSecondPassword ?? false;
    return ProfileBackgroundScaffold(
      appBar: PrimaryAppBar(
        title: hasSecondPassword
            ? 'secondary_password.change_page_title'.tr()
            : 'secondary_password.create_page_title'.tr(),
        backgroundColor: Colors.transparent,
        titleColor: AppColors.onPrimary,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _handleUpdatePasswordListener,
        child: ProfileFormScrollView(
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
                    node: _currentPwdNode,
                    nextNode: hasSecondPassword
                        ? _currentSecondaryPwdNode
                        : _newSecondaryPwdNode,
                    hintText: 'input'.tr(),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateEmptyField,
                  ),
                  if (hasSecondPassword) ...[
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    PrimaryTextField(
                      label: 'secondary_password.current_secondary_password'
                          .tr(),
                      isRequired: true,
                      controller: _currentSecondaryPwdCtrl,
                      node: _currentSecondaryPwdNode,
                      nextNode: _newSecondaryPwdNode,
                      hintText: 'input'.tr(),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: Validators.validateEmptyField,
                    ),
                  ],
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  PrimaryTextField(
                    label: hasSecondPassword
                        ? 'secondary_password.new_password'.tr()
                        : 'secondary_password.second_password'.tr(),
                    isRequired: true,
                    controller: _newSecondaryPwdCtrl,
                    node: _newSecondaryPwdNode,
                    nextNode: _confirmNewSecondaryPwdNode,
                    hintText: 'input'.tr(),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateSecondPassword,
                  ),
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  PrimaryTextField(
                    label: hasSecondPassword
                        ? 'secondary_password.confirm_new_password'.tr()
                        : 'secondary_password.confirm_second_password'.tr(),
                    isRequired: true,
                    controller: _confirmNewSecondaryPwdCtrl,
                    node: _confirmNewSecondaryPwdNode,
                    hintText: 'input'.tr(),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onUpdatePressed(),
                    validator: (value) =>
                        Validators.validateConfirmSecondPassword(
                          value,
                          _newSecondaryPwdCtrl.text,
                        ),
                  ),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  const Spacer(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.mediumSpacing,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SecondaryButton.filled(
                              label: hasSecondPassword
                                  ? 'secondary_password.button_update'.tr()
                                  : 'secondary_password.button_create'.tr(),
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
      ),
    );
  }

  void _onUpdatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final hasSecondPassword =
          _authBloc.userProfile.hasSecondPassword ?? false;

      if (hasSecondPassword) {
        final request = UpdateSecondPasswordRequest(
          currentPassword: _currentPwdCtrl.text.trim(),
          currentSecondPassword: _currentSecondaryPwdCtrl.text.trim(),
          newSecondPassword: _newSecondaryPwdCtrl.text.trim(),
        );
        _authBloc.updateSecondPassword(request);
      } else {
        final request = CreateSecondPasswordRequest(
          currentPassword: _currentPwdCtrl.text.trim(),
          secondPassword: _newSecondaryPwdCtrl.text.trim(),
        );
        _authBloc.createSecondPassword(request);
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
          PrimaryDialog.showSuccessDialog(
            context,
            message: 'secondary_password.update_success'.tr(),
            onClosed: () {
              if (mounted) context.pop(true);
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
