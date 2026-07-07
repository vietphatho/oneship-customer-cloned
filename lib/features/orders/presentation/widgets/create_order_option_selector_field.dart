import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';

class CreateOrderOptionSelectorField extends StatelessWidget {
  const CreateOrderOptionSelectorField({
    super.key,
    required this.label,
    required this.selectedNames,
    required this.routeName,
  });

  final String label;
  final String selectedNames;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final hasValue = selectedNames.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PrimaryText(label, style: AppTextStyles.bodySmall, bold: true),
            const PrimaryText(
              " *",
              style: AppTextStyles.labelMedium,
              color: AppColors.expenseRed,
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryAnimatedPressableWidget(
          onTap: () => context.push(routeName),
          child: PrimaryFrame(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryText(
                    hasValue ? selectedNames : "select".tr(),
                    style: AppTextStyles.bodySmall,
                    color: hasValue ? AppColors.neutral2 : AppColors.neutral5,
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: AppDimensions.smallIconSize,
                  color: AppColors.neutral5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
