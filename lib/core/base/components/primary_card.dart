import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/themes/app_box_shadows.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: AppBoxShadows.card,
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.mediumSpacing,
      ),
      child: child,
    );
  }
}
