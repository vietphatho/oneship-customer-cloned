import 'package:oneship_customer/core/base/base_import_components.dart';

import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';

class OrderStatusSummaryCard extends StatelessWidget {
  const OrderStatusSummaryCard({
    super.key,
    required this.status,
    required this.amount,
  });

  final OrderStatus status;
  final int amount;

  @override
  Widget build(BuildContext context) {
    // Determine light background color for the tag
    final Color bgColor = _getBgColor(status);
    final Color textColor = _getTextColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.smallSpacing,
        vertical: AppDimensions.smallSpacing,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.neutral8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Status tag
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.xxSmallSpacing,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppDimensions.smallBorderRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                status.buildIcon(width: 24, height: 24),
                const SizedBox(width: AppDimensions.xxSmallSpacing),
                Text(
                  status.value.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          // Amount
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: Utils.formatCurrencyWithUnit(amount).replaceAll('đ', '').trim(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: ' vnd',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.shipping: // if this maps to "Tìm shipper"
        return AppColors.orange.withValues(alpha: 0.1);
      case OrderStatus.cancelled:
        return AppColors.error.withValues(alpha: 0.1);
      case OrderStatus.batched:
        return AppColors.green.withValues(alpha: 0.1);
      case OrderStatus.returned:
        return AppColors.investmentPurple.withValues(alpha: 0.1);
      default:
        return AppColors.secondary.withValues(alpha: 0.1);
    }
  }

  Color _getTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.shipping:
        return AppColors.orange;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.batched:
        return AppColors.green;
      case OrderStatus.returned:
        return AppColors.investmentPurple;
      default:
        return AppColors.secondary;
    }
  }
}
