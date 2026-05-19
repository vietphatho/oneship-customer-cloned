import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';

class ShopStaffAddFooter extends StatelessWidget {
  const ShopStaffAddFooter({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.xSmallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.bottomNavBarHeight + AppDimensions.xxxLargeSpacing,
        ),
        child: SecondaryButton.iconFilled(
          label: "shop_management.staff_add_new".tr(),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: AppDimensions.smallIconSize,
          ),
          onPressed: onPressed,
          height: AppDimensions.smallHeightButton,
        ),
      ),
    );
  }
}
