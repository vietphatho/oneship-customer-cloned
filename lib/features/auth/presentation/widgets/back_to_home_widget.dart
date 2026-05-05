import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

class BackToHomeWidget extends StatelessWidget {
  const BackToHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: PrimaryAnimatedPressableWidget(
          onTap: () {
            context.pop();
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
