import 'package:flutter/material.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_checkbox_item.dart';

class OrderStatusFilterList extends StatelessWidget {
  const OrderStatusFilterList({
    super.key,
    required this.statuses,
    required this.selectedStatuses,
    required this.onChanged,
  });

  /// The list of available statuses to filter by
  final List<OrderStatus> statuses;

  /// The currently selected statuses
  final Set<OrderStatus> selectedStatuses;

  /// Callback when a status is toggled
  final ValueChanged<Set<OrderStatus>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: statuses.map((status) {
        return OrderStatusCheckboxItem(
          status: status,
          isSelected: selectedStatuses.contains(status),
          onChanged: (isSelected) {
            final newSelection = Set<OrderStatus>.from(selectedStatuses);
            if (isSelected == true) {
              newSelection.add(status);
            } else {
              newSelection.remove(status);
            }
            onChanged(newSelection);
          },
        );
      }).toList(),
    );
  }
}
