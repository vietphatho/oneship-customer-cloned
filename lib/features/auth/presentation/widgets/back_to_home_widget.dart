import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_shop/core/navigation/route_name.dart';

class BackToHomeWidget extends StatelessWidget {
  const BackToHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: PrimaryAnimatedPressableWidget(
          onTap: () {
            context.go(RouteName.homePage);
          },
          child: Padding(
            padding: AppDimensions.mediumPaddingAll,
            child: PrimaryText(
              "back_to_home".tr(),
              style: AppTextStyles.labelLarge.copyWith(
                decoration: TextDecoration.underline,
              ),
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
