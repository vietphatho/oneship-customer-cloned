import 'package:flutter/material.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_status_summary_card.dart';

class OrderStatusSummaryList extends StatelessWidget {
  const OrderStatusSummaryList({
    super.key,
    required this.summaryData,
  });

  /// Map of OrderStatus to the total amount (vnd)
  final Map<OrderStatus, int> summaryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: summaryData.entries.map((entry) {
        return OrderStatusSummaryCard(
          status: entry.key,
          amount: entry.value,
        );
      }).toList(),
    );
  }
}
