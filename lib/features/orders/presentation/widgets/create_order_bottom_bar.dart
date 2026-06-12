import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/utils.dart';

class CreateOrderBottomBar extends StatelessWidget {
  const CreateOrderBottomBar({super.key, required this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.mediumSpacing,
          AppDimensions.smallSpacing,
          AppDimensions.mediumSpacing,
          AppDimensions.mediumSpacing,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryText(
                    "temporary_total".tr(),
                    style: AppTextStyles.bodySmall,
                    color: AppColors.neutral5,
                  ),
                  PrimaryText(
                    Utils.formatCurrencyWithUnit(0),
                    color: AppColors.primary,
                    bold: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PrimaryButton.filled(
                label: "continue".tr(),
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
