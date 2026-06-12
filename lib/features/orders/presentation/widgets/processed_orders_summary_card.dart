import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/utils.dart';

class ProcessedOrdersSummaryCard extends StatelessWidget {
  const ProcessedOrdersSummaryCard({
    super.key,
    required this.totalOrders,
    required this.revenue,
    required this.returnedAmount,
  });

  final int totalOrders;
  final int revenue;
  final int returnedAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.largeSpacing),
      child: PrimaryFrame(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Background Color to match the image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
                child: Container(color: const Color(0xFFFFF2E8)), // Peach background
              ),
            ),
            // Background Image (smaller, aligned to the right)
            Positioned(
              right: 10, // Shift left a bit so it's not cut off
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/order_summary_bg.png',
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            // Foreground Content (Text)
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.mediumSpacing,
                top: AppDimensions.mediumSpacing,
                bottom: AppDimensions.mediumSpacing,
                right: 90, // Shift text left to avoid overlapping image
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.primary,
                    title: "Tổng đơn",
                    value: totalOrders.toString(),
                    unit: "Đơn",
                    valueColor: AppColors.primary,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.info,
                    title: "Doanh thu", // Or translate this if it exists
                    value: Utils.formatCurrencyInput(revenue),
                    unit: "vnd",
                    valueColor: AppColors.info,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  child: _SummaryStatItem(
                    icon: Icons.monetization_on_rounded,
                    iconColor: AppColors.green,
                    title: "returned".tr(), // Đã hoàn về
                    value: Utils.formatCurrencyInput(returnedAmount),
                    unit: "vnd",
                    valueColor: AppColors.green,
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStatItem extends StatelessWidget {
  const _SummaryStatItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.xxSmallSpacing),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 14,
                color: iconColor,
              ),
            ),
            AppSpacing.horizontal(4),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: PrimaryText(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.neutral3,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLine: 1,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: PrimaryText(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
            maxLine: 1,
          ),
        ),
        AppSpacing.vertical(4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: PrimaryText(
            unit,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.neutral4,
            ),
            maxLine: 1,
          ),
        ),
      ],
    );
  }
}
