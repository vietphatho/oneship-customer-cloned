import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';

class SecondPasswordReminderDialog {
  const SecondPasswordReminderDialog._();

  static void showIfNeeded(BuildContext context) {
    final authBloc = getIt.get<AuthBloc>();
    if (!authBloc.shouldShowSecondPasswordReminder) return;

    authBloc.dismissSecondPasswordReminder();
    PrimaryDialog.showQuestionDialog(
      context,
      title: 'secondary_password.reminder_title',
      message: 'secondary_password.reminder_description'.tr(),
      positiveButtonText: 'secondary_password.reminder_create',
      negativeButtonText: 'secondary_password.reminder_later',
      onPositiveTapped: () =>
          context.push(RouteName.changeSecondaryPasswordPage),
    );
  }
}
