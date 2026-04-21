import 'package:flutter/material.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';

class OrderStatusTabBar extends StatelessWidget {
  const OrderStatusTabBar({
    super.key,
    this.onTap,
    required this.items,
    required this.controller,
  });

  final List<OrderStatus> items;
  final void Function(int)? onTap;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      padding: EdgeInsets.zero,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: items.map(((status) => Tab(text: status.name))).toList(),
      onTap: onTap,
    );
  }
}
