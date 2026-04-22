import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/components/primary_button.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/components/shimmer_image.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:oneship_customer/features/auth/presentation/widgets/search_orders_info_widget.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ManagementBloc _managementBloc = getIt.get();

  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final FocusNode _phoneNumNode = FocusNode();
  final FocusNode _pwNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final isFormValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validateForm);
    pwdController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value =
        phoneController.text.isNotEmpty && pwdController.text.isNotEmpty;
  }

  @override
  void dispose() {
    phoneController.dispose();
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
          child: BlocListener<AuthBloc, AuthState>(
            bloc: _authBloc,
            listener: _handleListener,
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
                  top: AppDimensions.getSize(context).height / 5,
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
                          AppSpacing.vertical(84),
                          PrimaryTextField(
                            controller: phoneController,
                            label: "user_name".tr(),
                            hintText: "enter_user_name".tr(),
                            // maxLength: 10,
                            isRequired: true,
                            // validator: Validators.validateRequiredPhoneNum,
                            // keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            node: _phoneNumNode,
                            nextNode: _pwNode,
                          ),
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //       context,
                          //       PathRoutes.forgotPasswordPage,
                          //     );
                          //   },
                          //   child: Align(
                          //     alignment: Alignment.centerRight,
                          //     child: CustomText(
                          //       text: "forgot_password".tr(),
                          //       color: AppColors.appColor,
                          //       bold: true,
                          //     ),
                          //   ),
                          // ),
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
                          const SizedBox(height: 50),
                          ValueListenableBuilder(
                            valueListenable: isFormValid,
                            builder: (context, bool value, _) {
                              return PrimaryButton.primaryButton(
                                onPressed: _onLoginPressed,
                                label: "login".tr(),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryText(
                                "dont_have_an_account".tr(),
                                color: AppColors.grey600,
                              ),
                              PrimaryButton(
                                onPressed: () {
                                  context.push(RouteName.registerPage);
                                },
                                child: PrimaryText(
                                  "register".tr(),
                                  color: AppColors.primary,
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SearchOrdersInfoWidget(),
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
          _authBloc.fetchUserProfile();
          // context.pushReplacement(RouteName.homePage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    } else if (state is AuthFetchedUserProfileState) {
      switch (state.resource.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          _managementBloc
            ..setUserId(state.resource.data?.id ?? "")
            ..getShops();
          context.pushReplacement(RouteName.shopMasterPage);
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }

  void _onLoginPressed() {
    _authBloc.login(
      userName: phoneController.text.trim(),
      password: pwdController.text.trim(),
    );
  }
}

class _FloatingLogo extends StatefulWidget {
  final double amplitude;
  final Duration duration;

  const _FloatingLogo({
    super.key,
    this.amplitude = 8,
    this.duration = const Duration(milliseconds: 2800),
  });

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

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -widget.amplitude,
      end: widget.amplitude,
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
  final double amplitude;
  final Duration duration;

  const _FloatingSphere({
    super.key,
    this.amplitude = 6,
    this.duration = const Duration(milliseconds: 3200),
  });

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

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -widget.amplitude,
      end: widget.amplitude,
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
