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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            padding: AppDimensions.mediumPaddingAll,
            child: Icon(feature.icon, size: 32, color: AppColors.primary),
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
