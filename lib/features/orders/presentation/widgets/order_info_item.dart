import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tab_bar.dart';

class OrderInfoItem extends StatelessWidget {
  const OrderInfoItem({
    super.key,
    required this.order,
    required this.index,
    this.onTap,
    this.onRemoved,
    this.onConfirmOrdAtHub,
    this.leading,
  });

  final int index;
  final OrderInfo order;
  final Widget? leading;
  final void Function(OrderInfo order)? onTap;
  final void Function(OrderInfo order)? onRemoved;
  final void Function(OrderInfo order)? onConfirmOrdAtHub;

  @override
  Widget build(BuildContext context) {
    final OrderStatus statusEnum = _parseStatus(order.status);
    final Color bgColor = _getBgColor(statusEnum);
    final Color textColor = _getTextColor(statusEnum);

    return PrimaryDismissible(
      key: Key(order.id ?? ''),
      enable: onRemoved != null,
      confirmMessage: "are_you_want_to_delete_order".tr(),
      onDismissed: (direction) {
        onRemoved?.call(order);
      },
      child: PrimaryAnimatedPressableWidget(
        onTap: () => onTap?.call(order),
        child: Container(
          padding: const EdgeInsets.symmetric(
            // horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.smallSpacing,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.neutral8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) leading!,

              // Circular Status Icon
              Container(
                padding: EdgeInsets.all(AppDimensions.smallSpacing),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: statusEnum.buildIcon(
                  width: AppDimensions.smallIconSize,
                  height: AppDimensions.smallIconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.smallSpacing),

              // Content Column: Order Details + Status + Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ROW 1: Order Number
                    Text(
                      order.orderNumber ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral1,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ROW 2: Date Time & Status Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _formatDateAndTime(order.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutral4,
                          ),
                        ),
                        // Status Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              statusEnum.buildIcon(width: 12, height: 12),
                              const SizedBox(width: 4),
                              Text(
                                statusEnum.value.tr(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // ROW 3: Name and Phone
                    Text(
                      "${order.customerName} • ${Utils.formatPhoneNumber(order.phone)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutral4,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ROW 4: Address & Amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppColors.neutral4,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  order.fullAddress ??
                                      order.address ??
                                      "Không có địa chỉ",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimensions.smallSpacing),
                        // Amount
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Utils.formatCurrencyWithUnit(
                                  order.codAmount,
                                ).replaceAll('đ', '').trim(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              TextSpan(
                                text: ' vnd',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateAndTime(DateTime? date) {
    if (date == null) return "--";
    final localDate = date.toLocal();
    final dateStr =
        "${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year}";
    final timeStr =
        "${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}";
    return "$dateStr • $timeStr";
  }

  OrderStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return OrderStatus.pending;
    switch (statusStr.toLowerCase()) {
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
      case OrderStatus.returnInProgress:
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
      case OrderStatus.returnInProgress:
        return AppColors.investmentPurple;
      default:
        return AppColors.secondary;
    }
  }
}
