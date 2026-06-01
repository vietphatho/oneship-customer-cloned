import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

import '../../data/enum.dart' show ShopHomeFeature, ShopHomeFeatureExt;

class ShopHomeFeatureButton extends StatelessWidget {
  const ShopHomeFeatureButton({super.key, required this.feature});

  final ShopHomeFeature feature;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () {
        context.push(feature.routeName);
      },
      child: Column(
        children: [
          Container(
            width: AppDimensions.shopHomeButtonSize,
            height: AppDimensions.shopHomeButtonSize,
            decoration: BoxDecoration(
              gradient: AppColors.shopHomeButtonGradBg,
              shape: BoxShape.circle,
            ),
            padding: AppDimensions.xSmallPaddingAll,
            // child: SvgPicture.asset(
            //   feature.icon,
            //   width: AppDimensions.xLargeIconSize,
            //   height: AppDimensions.xLargeIconSize,
            // ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryText(
            feature.title.tr(),
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
