import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';

class PrimaryTabBar extends StatelessWidget {
  const PrimaryTabBar({
    super.key,
    this.onTap,
    required this.items,
    required this.controller,
    this.isScrollable,
    this.borderRadius,
    this.height,
  });

  final List<String> items;
  final void Function(int)? onTap;
  final TabController controller;
  final bool? isScrollable;
  final BorderRadius? borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.primary,
      ),
      child: TabBar(
        controller: controller,
        padding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        labelStyle: AppTextStyles.labelMedium,
        unselectedLabelColor: AppColors.primaryLight,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: AppDimensions.smallBorderRadius,
        ),
        indicatorPadding: EdgeInsets.zero,
        isScrollable: isScrollable ?? false,
        tabAlignment:
            isScrollable == true ? TabAlignment.start : TabAlignment.fill,
        tabs:
            items
                .map(
                  ((item) =>
                      Tab(text: item, height: AppDimensions.xxxLargeSpacing)),
                )
                .toList(),
        onTap: onTap,
      ),
    );
  }
}
