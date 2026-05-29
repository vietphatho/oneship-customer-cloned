import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/liquid_glass_view.dart';
import 'package:oneship_customer/core/base/components/primary_text_button.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/features/home/presentation/widgets/order_tracking_input_container.dart';

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
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            ImagePath.homeBackground,
            width: AppDimensions.getSize(context).width,
            // height: AppDimensions.getSize(context).height,
            fit: BoxFit.cover,
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
                  style: AppTextStyles.titleXXXLarge.copyWith(
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
                        const OrderTrackingInputContainer(),
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
