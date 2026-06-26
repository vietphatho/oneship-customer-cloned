import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_list_item_parts.dart';

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
    final statusEnum = parseOrderStatus(order.status);
    final bgColor = orderStatusBackgroundColor(statusEnum);
    final textColor = orderStatusForegroundColor(statusEnum);
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
          child: OrderListItemSurface(
            isSelected: isSelected,
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
                OrderListStatusIcon(
                  status: statusEnum,
                  backgroundColor: bgColor,
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
                          OrderListStatusPill(
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
                            child: OrderListInlineInfo(
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
                      OrderListInlineInfo(
                        icon: Icons.location_on_outlined,
                        value: address,
                        maxLines: 2,
                      ),
                      AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: OrderListInlineInfo(
                              icon: Icons.schedule_outlined,
                              value: formatOrderListDateTime(order.createdAt),
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
}
