import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final RegisterBloc _registerBloc = getIt<RegisterBloc>();
  final PinInputController _inputCtrl = PinInputController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listener: _handleVerifyEmailListener,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.logo,
                height: AppDimensions.smallHeightButton,
              ),
              AppSpacing.vertical(AppDimensions.xxLargeSpacing),
              PrimaryText(
                "verify_email".tr(),
                style: AppTextStyles.titleXXLarge,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryText("we_sent_an_email_to".tr()),
              AppSpacing.vertical(AppDimensions.xxSmallSpacing),
              PrimaryText(
                _registerBloc.state.email.toString(),
                style: AppTextStyles.titleLarge,
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryText("enter_verify_email_code".tr()),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              MaterialPinField(
                pinController: _inputCtrl,
                length: 6,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: Size(50, 50),
                  focusedFillColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryButton.filled(
                onPressed: () {
                  if (_inputCtrl.text.length == 6) {
                    _onVerifyEmailPressed();
                  }
                },
                label: "verify".tr(),
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              Divider(),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
              PrimaryText(
                "have_not_received_email".tr(),
                style: AppTextStyles.titleMedium,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _ResendVerificationEmailWidget(),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryTextButton(
                label: 'back_to_home'.tr(),
                onPressed: () {
                  context.pushReplacement(RouteName.homePage);
                },
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
      code: _inputCtrl.text,
      email: _registerBloc.state.email ?? '',
    );
  }
}

class _ResendVerificationEmailWidget extends StatefulWidget {
  const _ResendVerificationEmailWidget();

  @override
  State<_ResendVerificationEmailWidget> createState() =>
      __ResendVerificationEmailWidgetState();
}

class __ResendVerificationEmailWidgetState
    extends State<_ResendVerificationEmailWidget> {
  final RegisterBloc _registerBloc = getIt.get();
  static const int maxSeconds = 120;
  int _secondsLeft = maxSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      listener: (context, state) {
        switch (state.resendVerificationEmailResult!.state) {
          case Result.loading:
            PrimaryDialog.showLoadingDialog(context);
            break;
          case Result.success:
            PrimaryDialog.hideLoadingDialog(context);
            break;
          case Result.error:
            PrimaryDialog.hideLoadingDialog(context);
            PrimaryDialog.showErrorDialog(context);
            break;
        }
      },
      child: SecondaryButton.iconFilled(
        label: '${'resend'.tr()} ${_formatTime(_secondsLeft)}',
        icon: Icon(
          Icons.refresh_rounded,
          color: _secondsLeft == 0 ? Colors.white : AppColors.neutral6,
        ),
        onPressed:
            _secondsLeft == 0
                ? () {
                  _resendVerifyCode();
                }
                : null,
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();

    _secondsLeft = maxSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        t.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _resendVerifyCode() {
    _registerBloc.resendVerificationEmail();
    _startTimer();
  }
}
