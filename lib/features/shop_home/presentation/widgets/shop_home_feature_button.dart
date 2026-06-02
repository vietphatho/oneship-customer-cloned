import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

import '../../data/enum.dart' show ShopHomeFeature, ShopHomeFeatureExt;

class ShopHomeFeatureButton extends StatelessWidget {
  const ShopHomeFeatureButton({super.key, required this.feature});

  static const double _iconSize = 38;

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
            child: Center(
              child: SizedBox.square(
                dimension: _iconSize,
                child: SvgPicture.asset(feature.icon),
              ),
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.xxLargeSpacing + AppDimensions.smallSpacing,
            child: PrimaryText(
              feature.title.tr(),
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelXSmall,
            ),
          ),
        ],
      ),
    );
  }
}
