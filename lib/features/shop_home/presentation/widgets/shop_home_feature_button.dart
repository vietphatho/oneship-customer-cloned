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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppDimensions.largeBorderRadius,
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryText(
              feature.name,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium,
            ),
            Icon(Icons.add_box_rounded, size: 32),
          ],
        ),
      ),
    );
  }
}
