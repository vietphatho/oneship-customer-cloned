import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/features/finance/data/enum.dart';

class FinanceTabBar extends StatelessWidget {
  const FinanceTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return PrimaryTabBar(
      items: FinanceSubFeature.values.map((e) => e.name).toList(),
      controller: controller,
    );
  }
}
