import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_list_item_parts.dart';

class ProcessedOrderListItem extends StatelessWidget {
  const ProcessedOrderListItem({super.key, required this.order, this.onTap});

  final OrdersHistoryEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statusEnum = parseOrderStatus(order.status);
    final bgColor = orderStatusBackgroundColor(statusEnum);
    final textColor = orderStatusForegroundColor(statusEnum);
    final address = _firstNonEmpty(
      order.fullAddress,
      secondary: order.fullAddressOld,
      fallback: "no_address".tr(),
    );
    final customerName = _firstNonEmpty(order.customerName);
    final orderCode = _firstNonEmpty(
      order.orderNumber,
      secondary: order.trackingCode,
    );

    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: OrderListItemSurface(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderListStatusIcon(status: statusEnum, backgroundColor: bgColor),
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
    );
  }

  String _firstNonEmpty(
    String? primary, {
    String? secondary,
    String? fallback,
  }) {
    final primaryText = primary?.trim();
    if (primaryText?.isNotEmpty == true) return primaryText!;

    final secondaryText = secondary?.trim();
    if (secondaryText?.isNotEmpty == true) return secondaryText!;

    return fallback ?? "--";
  }
}
