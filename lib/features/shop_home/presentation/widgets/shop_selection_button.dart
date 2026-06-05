import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  static const double _buttonSize = AppDimensions.homeAvatarRadius * 2;
  static const double _iconSize = AppDimensions.mediumIconSize;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: () {
        context.push(RouteName.shopSelectionPage);
      },
      child: SizedBox.square(
        dimension: _buttonSize,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Image.asset(ImagePath.shopHomeAvatarBackground, fit: BoxFit.cover),
            Center(
              child: Image.asset(
                ImagePath.shopHomeStore,
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
