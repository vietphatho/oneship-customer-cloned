import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class IconLabelTabItem {
  const IconLabelTabItem({required this.label, required this.iconPath});

  final String label;

  final String iconPath;
}

class IconLabelTabBar extends StatelessWidget {
  const IconLabelTabBar({
    super.key,
    required this.controller,
    required this.items,
    this.onTap,
    this.tabHeight = 60,
    this.iconSize = 24,
  });

  final TabController controller;
  final List<IconLabelTabItem> items;
  final void Function(int index)? onTap;

  final double tabHeight;

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumSpacing,
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: TabBar(
        controller: controller,
        padding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        labelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelColor: AppColors.primaryLight,
        indicator: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: AppDimensions.smallBorderRadius,
        ),
        indicatorPadding: EdgeInsets.zero,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: onTap,
        tabs: items.map((item) {
          return Tab(
            height: tabHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(item.iconPath),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIcon(String path) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(path, width: iconSize, height: iconSize);
    }
    return Image.asset(path, width: iconSize, height: iconSize);
  }
}
