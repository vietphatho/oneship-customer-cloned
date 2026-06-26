import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';

class OrderListItemSurface extends StatelessWidget {
  const OrderListItemSurface({
    super.key,
    required this.child,
    this.isSelected = false,
  });

  final Widget child;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.short2,
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryLight.withValues(alpha: 0.38)
            : Colors.white,
        borderRadius: AppDimensions.smallBorderRadius,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.neutral8,
          width: isSelected
              ? AppDimensions.mediumBorderStroke
              : AppDimensions.smallBorderStroke,
        ),
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: child,
    );
  }
}

class OrderListStatusIcon extends StatelessWidget {
  const OrderListStatusIcon({
    super.key,
    required this.status,
    required this.backgroundColor,
  });

  final OrderStatus status;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Padding(
        padding: AppDimensions.xSmallPaddingAll,
        child: status.buildIcon(
          width: AppDimensions.smallIconSize,
          height: AppDimensions.smallIconSize,
        ),
      ),
    );
  }
}

class OrderListStatusPill extends StatelessWidget {
  const OrderListStatusPill({
    super.key,
    required this.status,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final OrderStatus status;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xSmallSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimensions.xSmallBorderRadius,
      ),
      child: PrimaryText(
        status.value.tr(),
        style: AppTextStyles.bodyXXSmall.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        maxLine: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class OrderListInlineInfo extends StatelessWidget {
  const OrderListInlineInfo({
    super.key,
    required this.icon,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: AppDimensions.xSmallIconSize,
          color: AppColors.neutral5,
        ),
        AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
        Expanded(
          child: PrimaryText(
            value,
            style: AppTextStyles.bodyXXSmall.copyWith(
              color: AppColors.neutral4,
            ),
            maxLine: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

OrderStatus parseOrderStatus(String? statusStr) {
  switch (statusStr?.trim().toLowerCase()) {
    case 'at_hub':
      return OrderStatus.atHub;
    case 'pending':
      return OrderStatus.pending;
    case 'processing':
      return OrderStatus.processing;
    case 'batched':
      return OrderStatus.batched;
    case 'shipping':
      return OrderStatus.shipping;
    case 'delayed':
      return OrderStatus.delayed;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    case 'returned':
      return OrderStatus.returned;
    case 'return_in_progress':
      return OrderStatus.returnInProgress;
    default:
      return OrderStatus.pending;
  }
}

Color orderStatusBackgroundColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
    case OrderStatus.shipping:
      return AppColors.orange.withValues(alpha: 0.1);
    case OrderStatus.cancelled:
      return AppColors.error.withValues(alpha: 0.1);
    case OrderStatus.batched:
    case OrderStatus.delivered:
      return AppColors.green.withValues(alpha: 0.1);
    case OrderStatus.returned:
    case OrderStatus.returnInProgress:
      return AppColors.investmentPurple.withValues(alpha: 0.1);
    default:
      return AppColors.secondary.withValues(alpha: 0.1);
  }
}

Color orderStatusForegroundColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
    case OrderStatus.shipping:
      return AppColors.orange;
    case OrderStatus.cancelled:
      return AppColors.error;
    case OrderStatus.batched:
    case OrderStatus.delivered:
      return AppColors.green;
    case OrderStatus.returned:
    case OrderStatus.returnInProgress:
      return AppColors.investmentPurple;
    default:
      return AppColors.secondary;
  }
}

String formatOrderListDateTime(DateTime? date) {
  if (date == null) return "--";
  final localDate = date.toLocal();
  final dateStr =
      "${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year}";
  final timeStr =
      "${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}";
  return "$dateStr • $timeStr";
}
