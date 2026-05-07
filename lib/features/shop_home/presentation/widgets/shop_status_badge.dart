import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

class ShopStatusBadge extends StatelessWidget {
  final BriefShopEntity shop;

  const ShopStatusBadge({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final status = shop.shopStatus?.toLowerCase() ?? '';
    final bool isActive = status == 'active';
    final bool isPending = status == 'pending';

    final Color bgColor;
    final Color textColor;
    final String label;

    if (isActive) {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      label = 'shop_management.status_active'.tr();
    } else if (isPending) {
      bgColor = const Color(0xFFFFF3E0);
      textColor = const Color(0xFFE65100);
      label = 'shop_management.status_pending'.tr();
    } else {
      bgColor = const Color(0xFFEEEEEE);
      textColor = AppColors.neutral4;
      label = 'shop_management.status_inactive'.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
