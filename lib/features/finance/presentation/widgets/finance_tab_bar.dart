import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/features/finance/data/enum.dart';

extension _FinanceSubFeatureX on FinanceSubFeature {
  String get labelKey {
    return switch (this) {
      FinanceSubFeature.overview => 'overview',
      FinanceSubFeature.reconciliation => 'period',
      FinanceSubFeature.settlementCycle => 'reconciliation_cycle',
    };
  }

  String get icon {
    return switch (this) {
      FinanceSubFeature.overview => 'assets/icons/finance_overview.svg',
      FinanceSubFeature.reconciliation => 'assets/icons/finance_calendar.svg',
      FinanceSubFeature.settlementCycle =>
        'assets/icons/finance_reconciliation.svg',
    };
  }
}

class FinanceTabBar extends StatelessWidget {
  const FinanceTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Material(
          color: Colors.white,
          child: SizedBox(
            height: 48,
            child: TabBar(
              controller: controller,
              labelPadding: EdgeInsets.zero,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColors.grey200,
              tabs: FinanceSubFeature.values
                  .map(
                    (item) => _FinanceTabItem(
                      label: item.labelKey.tr(),
                      asset: item.icon,
                      selected: controller.index == item.index,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _FinanceTabItem extends StatelessWidget {
  const _FinanceTabItem({
    required this.label,
    required this.asset,
    required this.selected,
  });

  final String label;
  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.grey500;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          asset,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
