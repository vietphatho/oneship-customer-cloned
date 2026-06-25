import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/profile/presentation/widgets/profile_background_scaffold.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  static const _emptyText = '--';
  final AuthBloc _authBloc = getIt.get();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _setProfileFields();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBackgroundScaffold(
      appBar: PrimaryAppBar(
        title: 'account_info.page_title'.tr(),
        backgroundColor: Colors.transparent,
        titleColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child: Form(
          key: _formKey,
          child: BlocListener<AuthBloc, AuthState>(
            bloc: _authBloc,
            listener: _handleUpdateProfileListener,
            child: Column(
              children: [
                PrimaryTextField(
                  label: 'account_info.field_name'.tr(),
                  isRequired: true,
                  controller: _nameCtrl,
                  enabled: isEdit,
                  validator: Validators.validateEmptyField,
                ),
                AppSpacing.vertical(AppDimensions.largeSpacing),
                PrimaryTextField(
                  label: 'account_info.field_email'.tr(),
                  controller: _emailCtrl,
                  enabled: false,
                ),
                AppSpacing.vertical(AppDimensions.largeSpacing),
                PrimaryTextField(
                  label: 'account_info.field_phone'.tr(),
                  isRequired: true,
                  controller: _phoneCtrl,
                  enabled: isEdit,
                  keyboardType: TextInputType.number,
                  validator: Validators.validatePhoneNumber,
                ),
                Spacer(),
                _handleChangedUpdateProfileButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdateProfileListener(BuildContext context, AuthState state) {
    if (state is AuthUpdatedUserProfileState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          setState(() {
            isEdit = !isEdit;
          });
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }

  void _setProfileFields() {
    final userProfile = _authBloc.userProfile;

    _nameCtrl.text = _textOr(userProfile.displayName);
    _emailCtrl.text = _emailText(userProfile.userEmail);
    _phoneCtrl.text = _textOr(userProfile.userPhone);
  }

  String _textOr(String? value) {
    final text = value?.trim();
    if (text != null && text.isNotEmpty) return text;

    return _emptyText;
  }

  String _emailText(String? value) {
    return _textOr(value);
  }

  Widget _handleChangedUpdateProfileButton() {
    if (isEdit == false) {
      return SafeArea(
        child: SecondaryButton.filled(
          label: 'account_info.button_update'.tr(),
          onPressed: () {
            setState(() {
              isEdit = !isEdit;
            });
          },
        ),
      );
    } else {
      return SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton.outlined(
                label: 'cancel'.tr(),
                onPressed: () {
                  _setProfileFields();

                  setState(() {
                    isEdit = !isEdit;
                  });
                },
              ),
            ),
            AppSpacing.horizontal(AppDimensions.mediumSpacing),
            Expanded(
              child: SecondaryButton.filled(
                label: 'confirm'.tr(),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _authBloc.updateUserProfile(
                      displayName: _nameCtrl.text.trim(),
                      userPhone: _phoneCtrl.text.trim(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
