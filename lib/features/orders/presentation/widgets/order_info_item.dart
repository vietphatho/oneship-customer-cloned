import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_dismissible.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_tag.dart';

class OrderInfoItem extends StatelessWidget {
  const OrderInfoItem({
    super.key,
    required this.order,
    required this.index,
    this.onTap,
    this.onRemoved,
  });

  final int index;
  final OrderInfo order;
  final void Function(OrderInfo order)? onTap;
  final void Function(OrderInfo order)? onRemoved;

  @override
  Widget build(BuildContext context) {
    return PrimaryDismissible(
      key: Key(order.id ?? ''),
      enable: onRemoved != null,
      confirmMessage: "are_you_want_to_delete_order".tr(),
      onDismissed: (direction) {
        onRemoved?.call(order);
      },
      child: PrimaryAnimatedPressableWidget(
        onTap: () => onTap?.call(order),
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
                        PrimaryText("#$index.", style: AppTextStyles.bodySmall),
                        AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
                        Expanded(
                          child: PrimaryText(
                            order.orderNumber,
                            style: AppTextStyles.labelSmall,
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
              PrimaryText(
                "${"cod".tr()}: ${order.codAmount}",
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral2,
              ),
              AppSpacing.vertical(AppDimensions.xxxSmallSpacing),
              PrimaryText(
                "${"created_at".tr()}: ${order.createdAt}",
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
