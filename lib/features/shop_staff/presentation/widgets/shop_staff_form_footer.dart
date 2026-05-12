import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/components/tertiary_button.dart';

class ShopStaffFormFooter extends StatelessWidget {
  const ShopStaffFormFooter({
    super.key,
    required this.primaryLabel,
    required this.onSubmit,
  });

  final String primaryLabel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.smallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.mediumSpacing,
        ),
        child: Row(
          children: [
            Expanded(
              child: TertiaryButton.filled(
                label: "shop_management.cancel".tr(),
                onPressed: () => context.pop(),
                height: AppDimensions.smallHeightButton,
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              flex: 2,
              child: SecondaryButton.filled(
                label: primaryLabel,
                onPressed: onSubmit,
                height: AppDimensions.smallHeightButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
