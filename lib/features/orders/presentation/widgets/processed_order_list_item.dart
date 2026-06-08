import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';

class ProcessedOrderListItem extends StatelessWidget {
  const ProcessedOrderListItem({
    super.key,
    required this.order,
    this.onTap,
  });

  final OrdersHistoryEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTimeUtils.formatDateTime(order.createdAt) ?? "--";
    final isDelivered = order.status == OrderStatus.delivered.value;
    final isReturned = order.status == OrderStatus.returned.value;

    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: PrimaryFrame(
        padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading package icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/package_icon.png", // Assuming this asset exists
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.mediumSpacing),
            
            // Middle and Trailing sections grouped for top-alignment
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Middle section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          "#${order.orderNumber ?? '--'}",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.neutral1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        PrimaryText(
                          createdAt, // e.g. 05/05/2025 • 14:30
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.neutral4,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        PrimaryText(
                          "Người nhận: ${order.customerName ?? '--'}",
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.neutral2,
                          ),
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  
                  // Trailing section
                  Padding(
                    padding: const EdgeInsets.only(top: 6), // Shift down slightly to align with text baseline
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusChip(
                          label: order.status,
                          isDelivered: isDelivered,
                        ),
                        AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Utils.formatCurrencyInput(order.codAmount),
                                style: AppTextStyles.titleLarge.copyWith( // Enlarged
                                  color: AppColors.accentColor1, // Orange color
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: " vnd",
                                style: AppTextStyles.labelSmall.copyWith( // Enlarged
                                  color: AppColors.accentColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.smallSpacing), // Increased space to move chip down
                        _PaymentMethodChip(
                          paymentMethod: order.paymentMethod ?? "COD",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            
            // Chevron
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.neutral4,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.isDelivered,
  });

  final String label;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDelivered ? AppColors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1);
    final textColor = isDelivered ? AppColors.green : AppColors.primary;
    final icon = isDelivered ? Icons.check_circle_rounded : Icons.cached_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6), // Less rounded, to match image
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          AppSpacing.horizontal(4),
          PrimaryText(
            label.tr(),
            style: AppTextStyles.labelXSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  const _PaymentMethodChip({required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final isCOD = paymentMethod.toUpperCase() == "COD";
    final color = isCOD ? AppColors.primary : AppColors.neutral4;
    final bgColor = isCOD ? AppColors.primary.withOpacity(0.1) : Colors.transparent;

    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 2,
        bottom: 4, // Add more bottom padding to push text visually upwards
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: PrimaryText(
        isCOD ? "COD" : paymentMethod,
        style: AppTextStyles.labelSmall.copyWith( // Enlarged from labelXSmall
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.1, // Adjust line height
        ),
      ),
    );
  }
}
