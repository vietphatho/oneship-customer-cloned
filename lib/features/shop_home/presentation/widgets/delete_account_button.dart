import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = getIt.get();

    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _listenDeleteAccountState,
      child: PrimaryAnimatedPressableWidget(
        onTap: () {
          PrimaryDialog.showQuestionDialog(
            context,
            message: "do_you_want_to_delete_account".tr(),
            onPositiveTapped: _authBloc.deleteAccount,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.largeSpacing,
          ),
          child: PrimaryText(
            "delete_account".tr(),
            color: AppColors.red500,
            style: AppTextStyles.labelMedium,
          ),
        ),
      ),
    );
  }

  void _listenDeleteAccountState(BuildContext context, AuthState state) {
    if (state is AuthDeleteAccountState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showSuccessDialog(
            context,
            message: "account_deleted".tr(),
            onClosed: () {
              context.go(RouteName.homePage);
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
