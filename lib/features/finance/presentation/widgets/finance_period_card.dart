import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_shop/core/base/components/primary_card.dart';
import 'package:oneship_shop/core/base/components/primary_status.dart';
import 'package:oneship_shop/core/utils/date_time_utils.dart';
import 'package:oneship_shop/core/utils/utils.dart';
import 'package:oneship_shop/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_shop/features/finance/enum.dart';

class FinancePeriodCard extends StatelessWidget {
  const FinancePeriodCard({
    super.key,
    required this.periodEntity,
    required this.onTap,
  });

  final PeriodEntity periodEntity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: PrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PrimaryText(
                  periodEntity.periodCode,
                  style: AppTextStyles.titleXLarge,
                ),
                Spacer(),
                PrimaryStatus(
                  label: '${periodEntity.status?.tr()}',
                  color: periodEntity.periodStatus.getStatusColor() ?? AppColors.primary,
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            PrimaryText(
              '${DateTimeUtils.formatterString(periodEntity.startedAt)}-${DateTimeUtils.formatterString(periodEntity.endedAt)} | ${periodEntity.periodType?.tr()}',
              style: AppTextStyles.bodyMedium,
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
            Row(
              children: [
                PrimaryText(
                  'total_income'.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                Spacer(),
                PrimaryText(
                  Utils.formatCurrencyWithUnit(periodEntity.totalIn),
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            Row(
              children: [
                PrimaryText(
                  'total_expense'.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                Spacer(),
                PrimaryText(
                  Utils.formatCurrencyWithUnit(periodEntity.totalOut),
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            Row(
              children: [
                PrimaryText(
                  'net_payable'.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                Spacer(),
                PrimaryText(
                  Utils.formatCurrencyWithUnit(periodEntity.netPayable),
                  style: AppTextStyles.labelLarge,
                  color: AppColors.primary,
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            Row(
              children: [
                PrimaryText(
                  'order_count'.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                Spacer(),
                PrimaryText(
                  periodEntity.orderCount.toString(),
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
