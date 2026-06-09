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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => onLongPress?.call(order),
      child: OrderInfoItem(
        index: index,
        order: order,
        onTap: onTap, // Let OrderInfoItem handle the tap
        onRemoved: onRemoved,
        onConfirmOrdAtHub: onConfirmOrdAtHub,
        leading: showSelectionControl
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0, right: AppDimensions.smallSpacing),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onLongPress?.call(order), // Use onLongPress for selection toggle
                    activeColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
