import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/components/primary_button.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_state.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final RegisterBloc _registerBloc = getIt<RegisterBloc>();

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listener: _handleVerifyEmailListener,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verify Email Page"),
              SizedBox(height: 16),
              Text("Verify your email: ${_registerBloc.state.email}"),
              SizedBox(height: 16),
              PrimaryTextField(
                label: "Verification Code",
                controller: _verificationCodeController,
              ),
              SizedBox(height: 16),
              SafeArea(
                child: PrimaryButton(
                  onPressed: () {
                    _onVerifyEmailPressed();
                  },
                  label: "Send Verification Email",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVerifyEmailListener(BuildContext context, RegisterState state) {
    switch (state.verifyEmailResult!.state) {
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

  void _onVerifyEmailPressed() {
    _registerBloc.verifyEmailRequest(
      code: _verificationCodeController.text.trim(),
      email: _registerBloc.state.email ?? '',
    );
  }
}
