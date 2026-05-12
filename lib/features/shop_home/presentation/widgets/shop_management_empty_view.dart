import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/themes/app_spacing.dart';

class ShopManagementEmptyView extends StatelessWidget {
  const ShopManagementEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 80, color: AppColors.neutral6),
          AppSpacing.vertical(16),
          Text(
            'shop_management.empty_title'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.neutral5,
                ),
          ),
          AppSpacing.vertical(8),
          Text(
            'shop_management.empty_subtitle'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.neutral6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
