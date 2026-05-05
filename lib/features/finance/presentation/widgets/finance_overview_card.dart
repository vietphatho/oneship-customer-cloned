import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';

class FinanceOverviewCard extends StatelessWidget {
  const FinanceOverviewCard({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: AppColors.secondary,
                  size: AppDimensions.mediumIconSize,
                ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              Expanded(
                child: PrimaryText(
                  label,
                  style: AppTextStyles.labelMedium,
                  color: AppColors.secondary,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryText(
              value,
              style: AppTextStyles.labelMedium,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
