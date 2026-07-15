import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

class ForgotSecondaryPasswordListener extends StatelessWidget {
  const ForgotSecondaryPasswordListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt.get<AuthBloc>(),
      listener: ForgotSecondaryPasswordDialog.handleState,
      child: child,
    );
  }
}

class ForgotSecondaryPasswordDialog {
  const ForgotSecondaryPasswordDialog._();

  static void show(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();
    final email = authBloc.userProfile.userEmail?.trim();

    if (email == null || email.isEmpty) {
      PrimaryDialog.showErrorDialog(
        context,
        message: 'secondary_password.forgot_email_missing',
      );
      return;
    }

    PrimaryDialog.showQuestionDialog(
      context,
      title: 'secondary_password.forgot_title',
      message: 'secondary_password.forgot_confirm_message'.tr(
        namedArgs: {'email': email},
      ),
      negativeButtonText: 'cancel',
      positiveButtonText: 'secondary_password.forgot_send_request',
      onPositiveTapped: () => authBloc.forgotSecondaryPassword(email: email),
    );
  }

  static void handleState(BuildContext context, AuthState state) {
    if (state is! AuthForgotSecondaryPasswordState) return;

    switch (state.resource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showSuccessDialog(
          context,
          message: 'secondary_password.forgot_success_message',
        );
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context, message: state.resource.message);
        break;
    }
  }
}
