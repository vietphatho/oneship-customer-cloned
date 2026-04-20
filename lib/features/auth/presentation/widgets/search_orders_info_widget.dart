import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';

class SearchOrdersInfoWidget extends StatelessWidget {
  const SearchOrdersInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: PrimaryAnimatedPressableWidget(
          onTap: () {
            context.push(RouteName.orderTrackingPage);
          },
          child: Padding(
            padding: AppDimensions.mediumPaddingAll,
            child: PrimaryText(
              "order_tracking".tr(),
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
