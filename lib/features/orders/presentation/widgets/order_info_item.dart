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
    this.onLongPress,
    this.onSelectionToggle,
    this.onRemoved,
    this.onConfirmOrdAtHub,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  final int index;
  final OrderInfo order;
  final void Function(OrderInfo order)? onTap;
  final void Function(OrderInfo order)? onLongPress;
  final void Function(OrderInfo order)? onSelectionToggle;
  final void Function(OrderInfo order)? onRemoved;
  final void Function(OrderInfo order)? onConfirmOrdAtHub;
  final bool isSelectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final OrderStatus statusEnum = _parseStatus(order.status);
    final Color bgColor = _getBgColor(statusEnum);
    final Color textColor = _getTextColor(statusEnum);
    final String address =
        order.fullAddress ?? order.address ?? "no_address".tr();
    final String customerName = order.customerName?.trim().isNotEmpty == true
        ? order.customerName!.trim()
        : "--";
    final String orderCode = order.orderNumber?.trim().isNotEmpty == true
        ? order.orderNumber!.trim()
        : (order.trackingCode?.trim().isNotEmpty == true
              ? order.trackingCode!.trim()
              : "--");

    return PrimaryDismissible(
      key: Key(order.id ?? ''),
      enable: onRemoved != null && !isSelectionMode,
      confirmMessage: "are_you_want_to_delete_order".tr(),
      onDismissed: (direction) {
        onRemoved?.call(order);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          (onLongPress ?? onSelectionToggle)?.call(order);
        },
        child: PrimaryAnimatedPressableWidget(
          onTap: () {
            if (isSelectionMode) {
              onSelectionToggle?.call(order);
              return;
            }
            onTap?.call(order);
          },
          child: AnimatedContainer(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: Durations.short2,
                  child: isSelectionMode
                      ? Padding(
                          key: const ValueKey("order_selection_checkbox"),
                          padding: const EdgeInsets.only(
                            right: AppDimensions.xSmallSpacing,
                          ),
                          child: SizedBox.square(
                            dimension: AppDimensions.mediumIconSize,
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (_) => onSelectionToggle?.call(order),
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDimensions.xSmallBorderRadius,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
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
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PrimaryText(
                              orderCode,
                              style: AppTextStyles.labelXSmall.copyWith(
                                color: AppColors.neutral1,
                              ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          _StatusPill(
                            status: statusEnum,
                            backgroundColor: bgColor,
                            foregroundColor: textColor,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: _InlineInfo(
                              icon: Icons.person_outline,
                              value:
                                  "$customerName • ${Utils.formatPhoneNumber(order.phone)}",
                            ),
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          PrimaryText(
                            Utils.formatCurrencyWithUnit(order.codAmount),
                            style: AppTextStyles.labelXSmall.copyWith(
                              color: textColor,
                            ),
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                      _InlineInfo(
                        icon: Icons.location_on_outlined,
                        value: address,
                        maxLines: 2,
                      ),
                      AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: _InlineInfo(
                              icon: Icons.schedule_outlined,
                              value: _formatDateAndTime(order.createdAt),
                            ),
                          ),
                          if (order.trackingCode?.trim().isNotEmpty == true &&
                              order.trackingCode != order.orderNumber) ...[
                            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                            Flexible(
                              child: PrimaryText(
                                order.trackingCode,
                                style: AppTextStyles.bodyXXSmall.copyWith(
                                  color: AppColors.neutral5,
                                ),
                                maxLine: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // status.buildIcon(
          //   width: AppDimensions.xxSmallIconSize,
          //   height: AppDimensions.xxSmallIconSize,
          // ),
          // AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
          PrimaryText(
            status.value.tr(),
            style: AppTextStyles.bodyXXSmall.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({
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
