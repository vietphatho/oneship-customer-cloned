import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/liquid_glass_view.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/navigation/route_observer_page.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImagePath.homeBackground,
          width: AppDimensions.getSize(context).width,
          height: AppDimensions.getSize(context).height,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: AppDimensions.getSize(context).width,
            height: AppDimensions.getSize(context).height / 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffF4C96B).withAlpha(130), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: AppDimensions.getSize(context).width,
            height: AppDimensions.getSize(context).height / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xffFFB16F),
                  Color(0xffFF7A00),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: AppDimensions.getSize(context).width,
            height: AppDimensions.getSize(context).height,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.mediumSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: AppSpacing.vertical(AppDimensions.mediumSpacing),
                ),
                PrimaryText(
                  'delivery_solutions'.tr(),
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryText(
                  'company_slogan'.tr(),
                  style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                ),
                Spacer(),
                LiquidGlassView(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.largeRadius),
                    topRight: Radius.circular(AppDimensions.largeRadius),
                  ),
                  opacity: 0.2,
                  blurness: 6,
                  child: Padding(
                    padding: AppDimensions.mediumPaddingAll,
                    child: Column(
                      children: [
                        AppSpacing.vertical(AppDimensions.smallSpacing),
                        Image.asset(
                          ImagePath.logo,
                          height: AppDimensions.smallHeightButton,
                        ),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        _OrderTrackingInputContainer(),
                        AppSpacing.vertical(AppDimensions.xxLargeSpacing),
                        _AuthActionButtons(),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        PrimaryText(
                          'company_name'.tr(),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthActionButtons extends StatelessWidget {
  const _AuthActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryTextButton(
          label: "log_in".tr(),
          onPressed: () {
            context.push(RouteName.loginPage);
          },
          labelColor: Colors.white,
        ),
        AppSpacing.horizontal(AppDimensions.smallSpacing),
        Container(width: 2, height: 24, color: Colors.white),
        AppSpacing.horizontal(AppDimensions.smallSpacing),
        PrimaryTextButton(
          label: "sign_up".tr(),
          onPressed: () {
            context.push(RouteName.registerPage);
          },
          labelColor: Colors.white,
        ),
      ],
    );
  }
}

class _OrderTrackingInputContainer extends StatefulWidget {
  const _OrderTrackingInputContainer();

  @override
  State<_OrderTrackingInputContainer> createState() =>
      _OrderTrackingInputContainerState();
}

class _OrderTrackingInputContainerState
    extends State<_OrderTrackingInputContainer> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();

  final TextEditingController _trackingNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _trackingNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Material(
            color: Colors.transparent,
            child: PrimaryTextField(
              controller: _trackingNumberCtrl,
              textInputAction: TextInputAction.done,
              hintText: 'input'.tr(),
            ),
          ),
        ),
        AppSpacing.horizontal(AppDimensions.smallSpacing),
        Expanded(
          child: BlocListener<OrderTrackingBloc, OrderTrackingState>(
            bloc: _orderTrackingBloc,
            listener: _handleOrderTrackingListener,
            child: PrimaryButton.filled(
              label: 'search'.tr(),
              onPressed: () {
                if (_trackingNumberCtrl.text.isNotEmpty) {
                  _orderTrackingBloc.search(_trackingNumberCtrl.text.trim());
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleOrderTrackingListener(
    BuildContext context,
    OrderTrackingState state,
  ) {
    var currentRoute = RouteObserverPage.currentRoute;
    if (currentRoute == RouteName.homePage) {
      switch (state.trackingResult!.state) {
        case Result.loading:
          PrimaryDialog.showLoadingDialog(context);
          break;
        case Result.success:
          PrimaryDialog.hideLoadingDialog(context);
          if (!(state.trackingResult?.data?.isEmpty ?? true)) {
            context.push(RouteName.orderTrackingPage);
          }
          break;
        case Result.error:
          PrimaryDialog.hideLoadingDialog(context);
          PrimaryDialog.showErrorDialog(context);
          break;
      }
    }
  }
}
