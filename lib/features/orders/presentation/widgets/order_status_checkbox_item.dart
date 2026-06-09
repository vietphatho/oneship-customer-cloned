import 'package:oneship_customer/core/base/base_import_components.dart';

import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';

class OrderStatusCheckboxItem extends StatelessWidget {
  const OrderStatusCheckboxItem({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onChanged,
  });

  final OrderStatus status;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _getBgColor(status);

    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallSpacing,
          vertical: AppDimensions.xSmallSpacing,
        ),
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.smallSpacing),
            // Circular icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: status.buildIcon(width: 24, height: 24),
            ),
            const SizedBox(width: AppDimensions.smallSpacing),
            // Status name
            Expanded(
              child: Text(
                status.value.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.shipping:
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
}
