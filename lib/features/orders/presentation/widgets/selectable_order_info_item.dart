import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';

class SelectableOrderInfoItem extends StatelessWidget {
  const SelectableOrderInfoItem({
    super.key,
    required this.index,
    required this.order,
    required this.isSelected,
    required this.showSelectionControl,
    this.onTap,
    this.onLongPress,
    this.onRemoved,
    this.onConfirmOrdAtHub,
  });

  final int index;
  final OrderInfo order;
  final bool isSelected;
  final bool showSelectionControl;
  final void Function(OrderInfo order)? onTap;
  final void Function(OrderInfo order)? onLongPress;
  final void Function(OrderInfo order)? onRemoved;
  final void Function(OrderInfo order)? onConfirmOrdAtHub;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showSelectionControl) ...[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap?.call(order),
            child: _SelectionIndicator(isSelected: isSelected),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
        ],
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () => onLongPress?.call(order),
            child: OrderInfoItem(
              index: index,
              order: order,
              onTap: onTap,
              onRemoved: onRemoved,
              onConfirmOrdAtHub: onConfirmOrdAtHub,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

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
          color: AppColors.secondary,
          width: AppDimensions.mediumBorderStroke * 1.5,
        ),
      ),
      child:
          isSelected
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
    );
  }
}
