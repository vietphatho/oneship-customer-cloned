import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';

import '../../data/enum.dart' show ShopHomeFeature, ShopHomeFeatureExt;

class ShopHomeFeatureButton extends StatelessWidget {
  const ShopHomeFeatureButton({super.key, required this.feature});

  static const double _iconSize = 56;
  static const double _labelWidth = 76;
  static const double _labelHeight = 30;

  final ShopHomeFeature feature;

  @override
  Widget build(BuildContext context) {
    final routeName = feature.routeName;

    return PrimaryAnimatedPressableWidget(
      onTap: routeName == null ? null : () => context.push(routeName),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: _iconSize,
              child: Image.asset(
                feature.icon,
                fit: BoxFit.contain,
              ),
            ),
            AppSpacing.vertical(AppDimensions.xxSmallSpacing),
            SizedBox(
              width: _labelWidth,
              height: _labelHeight,
              child: PrimaryText(
                feature.title.tr(),
                maxLine: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelXSmall.copyWith(
                  fontSize: 10,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
