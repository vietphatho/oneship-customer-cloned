import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';
import 'package:oneship_customer/core/themes/app_text_style.dart';

class PrimaryChipTabBar extends StatelessWidget {
  const PrimaryChipTabBar({
    super.key,
    required this.tabs,
    this.tabColors,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final List<Color>? tabColors;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.mediumSpacing),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (tabColors != null
                          ? tabColors![index].withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1))
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (tabColors != null ? tabColors![index] : AppColors.primary)
                        : AppColors.grey200,
                    width: 1,
                  ),
                ),
                child: PrimaryText(
                  tabs[index],
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 16,
                    color: tabColors != null
                        ? tabColors![index]
                        : (isSelected ? AppColors.primary : AppColors.grey500),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
