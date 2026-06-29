import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/components/primary_check_box.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/components/shimmer_image.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/network/token_manager.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/data/enum.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/register_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/widgets/back_to_home_widget.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ShopBloc _shopBloc = getIt.get();
  final PackagesBloc _packagesBloc = getIt.get();
  final VendorProfileBloc _vendorProfileBloc = getIt.get();
  final FinanceOverviewBloc financeOverviewBloc = getIt.get();
  final FinanceReconciliationBloc financeReconciliationBloc = getIt.get();

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final FocusNode _phoneNumNode = FocusNode();
  final FocusNode _pwNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final isFormValid = ValueNotifier<bool>(false);
  final isRememberMe = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(_validateForm);
    pwdController.addListener(_validateForm);
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    final tokenManager = TokenManager();
    final info = await tokenManager.getLoginInfo();
    if (info['isRememberMe'] == 'true') {
      isRememberMe.value = true;
      emailCtrl.text = info['username'] ?? '';
      pwdController.text = info['password'] ?? '';
    }
  }

  void _validateForm() {
    isFormValid.value =
        emailCtrl.text.isNotEmpty && pwdController.text.isNotEmpty;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: AppDimensions.getSize(context).height,
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                bloc: _authBloc,
                listener: _handleListener,
              ),
              BlocListener<ShopBloc, ShopState>(
                bloc: _shopBloc,
                listenWhen: (previous, current) =>
                    previous.briefShopsResource != current.briefShopsResource,
                listener: _listenShopsListChanged,
              ),
              BlocListener<ShopBloc, ShopState>(
                bloc: _shopBloc,
                listenWhen: (previous, current) =>
                    previous.currentShop != current.currentShop,
                listener: _listenCurrentShopChanged,
              ),
            ],
            child: Stack(
              children: [
                Container(
                  height: AppDimensions.getSize(context).height / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: const _FloatingLogo(),
                ),
                const Positioned(top: -30, left: -20, child: _FloatingSphere()),
                Positioned(
                  top: AppDimensions.getSize(context).height / 6,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: AppDimensions.mediumPaddingHorizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CustomText(
                          //   text: "welcome_to_oneship".tr(),
                          //   size: TextSize.h2,
                          //   bold: true,
                          // ),
                          Center(
                            child: ShimmerImage(
                              width: MediaQuery.of(context).size.width * 0.7,
                              image: const AssetImage(ImagePath.logo),
                            ),
                          ),
                          AppSpacing.vertical(56),
                          PrimaryTextField(
                            controller: emailCtrl,
                            label: "email".tr(),
                            hintText: "enter_email".tr(),
                            // maxLength: 10,
                            isRequired: true,
                            // validator: Validators.validateRequiredPhoneNum,
                            // keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            node: _phoneNumNode,
                            nextNode: _pwNode,
                          ),
                          AppSpacing.vertical(AppDimensions.smallSpacing),
                          PrimaryTextField(
                            controller: pwdController,
                            label: "password".tr(),
                            hintText: "enter_password".tr(),
                            isRequired: true,
                            obscureText: true,
                            // validator: Validators.validatePwd,
                            node: _pwNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _onLoginPressed();
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.smallSpacing),
                          ValueListenableBuilder<bool>(
                            valueListenable: isRememberMe,
                            builder: (context, value, child) {
                              return PrimaryCheckBox(
                                value: value,
                                onChanged: (val) {
                                  isRememberMe.value = val ?? false;
                                },
                                label: "Ghi nhớ đăng nhập",
                              );
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.smallSpacing),
                          ValueListenableBuilder(
                            valueListenable: isFormValid,
                            builder: (context, bool value, _) {
                              return SecondaryButton.filled(
                                onPressed: _onLoginPressed,
                                label: "login".tr(),
                              );
                            },
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          GestureDetector(
                            onTap: _onForgotPasswordPressed,
                            child: Align(
                              alignment: Alignment.center,
                              child: PrimaryText(
                                "forgot_password".tr(),
                                color: AppColors.primary,
                                style: AppTextStyles.labelMedium,
                                bold: true,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryText(
                                "dont_have_an_account".tr(),
                                color: AppColors.grey600,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(RouteName.registerPage);
                                },
                                child: PrimaryText(
                                  "register".tr(),
                                  color: AppColors.secondary,
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const BackToHomeWidget(),
                          // const AppVersionWidget(),
                        ],
                      ),
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

  void _handleListener(BuildContext context, AuthState state) {
    if (state is AuthLoggedInState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);

          TokenManager().saveLoginInfo(
            username: emailCtrl.text.trim(),
            password: pwdController.text.trim(),
            isRememberMe: isRememberMe.value,
          );

          if (state.resource.data?.refreshToken != null) {
            _authBloc.fetchUserProfile();
          } else {
            final RegisterBloc registerBloc = getIt.get();
            registerBloc.setUserEmail(
              state.resource.data!.userEmail.toString(),
            );
            context.pushReplacement(RouteName.verifyEmailPage);
          }
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(
            context,
            message: state.resource.message,
          );
          break;
      }
    } else if (state is AuthForgotPasswordState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showSuccessDialog(
            context,
            message: 'forgot_password_email_sent',
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
    } else if (state is AuthFetchedUserProfileState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          String? userRole = state.resource.data?.userRole;
          if (userRole == UserRole.shop.value) {
            _shopBloc.init(state.resource.data?.id ?? "");
          } else if (userRole == UserRole.vendor.value) {
            _vendorProfileBloc.init(forceRefresh: true);
            context.go(RouteName.vendorMasterPage);
          } else {
            _authBloc.logOut();
            context.go(RouteName.splashPage);
          }
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

  void _onForgotPasswordPressed() {
    final email = emailCtrl.text.trim();
    final validationMessage = _authBloc.validateForgotPasswordEmail(email);
    if (validationMessage != null) {
      PrimaryDialog.showErrorDialog(context, message: validationMessage);
      return;
    }

    PrimaryDialog.showQuestionDialog(
      context,
      message: 'forgot_password_confirm_message'.tr(),
      positiveButtonText: 'confirm',
      negativeButtonText: 'cancel',
      onPositiveTapped: () {
        _authBloc.forgotPassword(email: email);
      },
    );
  }

  void _onLoginPressed() {
    _authBloc.login(
      userName: emailCtrl.text.trim(),
      password: pwdController.text.trim(),
    );
  }

  void _listenShopsListChanged(BuildContext context, ShopState state) {
    switch (state.briefShopsResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        if (state.hasNoShops) {
          context.go(RouteName.shopEmptyPage);
        } else if (!state.hasApprovedShop) {
          context.go(RouteName.shopPendingApprovalPage);
        } else {
          // await Future.delayed(Durations.medium1);
          // final String shopId = state.currentShop?.shopId ?? "";
          // financeOverviewBloc.init(
          //   shopId: shopId,
          //   requestSource: FinanceRequestSource.page,
          // );
          // financeReconciliationBloc.initPeriods(shopId: shopId);

          // if (state.currentShop != null) {
          //   _packagesBloc.init(state.currentShop!);
          // }

          context.go(RouteName.shopMasterPage);
        }
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.briefShopsResource.message,
        );
        break;
    }
  }

  void _listenCurrentShopChanged(BuildContext context, ShopState state) {
    final String shopId = state.currentShop?.shopId ?? "";

    financeOverviewBloc.init(
      shopId: shopId,
      requestSource: FinanceRequestSource.page,
    );
    financeReconciliationBloc.initPeriods(shopId: shopId);

    if (state.currentShop != null) {
      _packagesBloc.init(state.currentShop!);
    }
  }
}

class _FloatingLogo extends StatefulWidget {
  static const double _amplitude = 8;
  static const Duration _duration = Duration(milliseconds: 2800);

  const _FloatingLogo();

  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _FloatingLogo._duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -_FloatingLogo._amplitude,
      end: _FloatingLogo._amplitude,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          ImagePath.logoBreak,
          fit: BoxFit.contain,
        ), // Logo placeholder
      ),
    );
  }
}

class _FloatingSphere extends StatefulWidget {
  static const double _amplitude = 6;
  static const Duration _duration = Duration(milliseconds: 3200);

  const _FloatingSphere();

  @override
  State<_FloatingSphere> createState() => _FloatingSphereState();
}

class _FloatingSphereState extends State<_FloatingSphere>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _FloatingSphere._duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -_FloatingSphere._amplitude,
      end: _FloatingSphere._amplitude,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        height: 148,
        width: 148,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withAlpha(10), Colors.white.withAlpha(50)],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
