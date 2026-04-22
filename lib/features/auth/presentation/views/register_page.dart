import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterBloc _registerBloc = getIt<RegisterBloc>();

  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  late final TextEditingController usernameController;
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    usernameController = TextEditingController();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "register".tr()),
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listener: _handleRegisterListener,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
              vertical: AppDimensions.mediumSpacing,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PrimaryTextField(
                          controller: usernameController,
                          label: "user_name".tr(),
                          isRequired: true,
                          validator: Validators.validateUsername,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: fullNameController,
                          label: "full_name".tr(),
                          isRequired: true,
                          validator: Validators.validateFullName,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: emailController,
                          label: "email".tr(),
                          isRequired: true,
                          validator: Validators.validateEmail,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: phoneNumberController,
                          label: "phone_number".tr(),
                          isRequired: true,
                          validator: Validators.validatePhoneNumber,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: passwordController,
                          label: "password".tr(),
                          obscureText: true,
                          isRequired: true,
                          validator: Validators.validatePassword,
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        PrimaryTextField(
                          controller: confirmPasswordController,
                          label: "confirm_pw".tr(),
                          obscureText: true,
                          isRequired: true,
                          validator:
                              (value) => Validators.validateConfirmPassword(
                                value,
                                passwordController.text,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: PrimaryButton.primaryButton(
                    label: "register".tr(),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _onRegisterPressed();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegisterListener(BuildContext context, RegisterState state) {
    switch (state.registerResult!.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.verifyEmailPage);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
        break;
    }
  }

  void _onRegisterPressed() {
    _registerBloc.registerRequest(
      userLogin: usernameController.text.trim(),
      displayName: fullNameController.text.trim(),
      userEmail: emailController.text.trim(),
      userPhone: phoneNumberController.text.trim(),
      userPass: passwordController.text.trim(),
      roleName: "shop",
    );
  }
}
