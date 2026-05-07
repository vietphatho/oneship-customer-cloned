import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
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
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: TabBar(
        controller: controller,
        padding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.primaryLight,
        indicator: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: AppDimensions.smallBorderRadius,
        ),
        indicatorPadding: EdgeInsets.zero,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs:
            items
                .map(
                  ((status) => Tab(
                    text: status.value.tr(),
                    height: AppDimensions.xxxLargeSpacing,
                  )),
                )
                .toList(),
        onTap: onTap,
      ),
    );
  }
}
