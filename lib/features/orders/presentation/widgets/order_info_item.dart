import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tag.dart';

class OrderInfoItem extends StatelessWidget {
  const OrderInfoItem({
    super.key,
    required this.order,
    required this.index,
    this.onTap,
    this.onLongPress,
    this.onRemoved,
    this.onConfirmOrdAtHub,
    this.isSelected = false,
    this.showSelectionControl = false,
  });

  final int index;
  final OrderInfo order;
  final void Function(OrderInfo order)? onTap;
  final void Function(OrderInfo order)? onLongPress;
  final void Function(OrderInfo order)? onRemoved;
  final void Function(OrderInfo order)? onConfirmOrdAtHub;
  final bool isSelected;
  final bool showSelectionControl;

  @override
  Widget build(BuildContext context) {
    return PrimaryDismissible(
      key: Key(order.id ?? ''),
      enable: onRemoved != null,
      confirmMessage: "are_you_want_to_delete_order".tr(),
      onDismissed: (direction) {
        onRemoved?.call(order);
      },
      child: Row(
        children: [
          if (showSelectionControl) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap?.call(order),
              child: _OrderSelectionIndicator(isSelected: isSelected),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
          ],
          Expanded(
            child: PrimaryAnimatedPressableWidget(
              onTap: () => onTap?.call(order),
              onLongPress: () => onLongPress?.call(order),
              child: PrimaryFrame(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.smallSpacing,
                  vertical: AppDimensions.xSmallSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              PrimaryText(
                                "#$index.",
                                style: AppTextStyles.bodySmall,
                              ),
                              AppSpacing.horizontal(
                                AppDimensions.xxSmallSpacing,
                              ),
                              Expanded(
                                child: PrimaryText(
                                  order.orderNumber,
                                  style: AppTextStyles.labelMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OrderStatusTag(status: order.status ?? "--"),
                      ],
                    ),
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                    PrimaryText(
                      "${order.customerName} - ${order.phone}",
                      style: AppTextStyles.bodySmall,
                      color: AppColors.neutral4,
                    ),
                    AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
                    Row(
                      children: [
                        PrimaryText(
                          "${"cod".tr()}:",
                          style: AppTextStyles.bodySmall,
                          color: AppColors.neutral4,
                        ),
                        AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
                        PrimaryText(
                          Utils.formatCurrencyWithUnit(order.codAmount),
                          style: AppTextStyles.bodySmall,
                          color: AppColors.neutral4,
                        ),
                      ],
                    ),
                    AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
                    PrimaryText(
                      "${"created_at".tr()}: ${DateTimeUtils.formatDateTime(order.createdAt?.toLocal())}",
                      style: AppTextStyles.bodySmall,
                      color: AppColors.neutral4,
                    ),
                    if (onConfirmOrdAtHub != null) ...[
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      SecondaryButton.filled(
                        label: "confirm".tr(),
                        height: AppDimensions.smallHeightButton,
                        onPressed: () => onConfirmOrdAtHub?.call(order),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSelectionIndicator extends StatelessWidget {
  const _OrderSelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.secondary,
          width: AppDimensions.mediumBorderStroke * 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : null,
    );
  }
}
