import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/shop_status_badge.dart';

class ShopCard extends StatelessWidget {
  final int index;
  final ShopEntity shop;

  const ShopCard({super.key, required this.index, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge
          Container(
            margin: const EdgeInsets.only(left: 12, top: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildRow(
            context,
            'shop_management.field_name'.tr(),
            shop.shopName,
          ),
          _buildRow(
            context,
            'shop_management.field_address'.tr(),
            shop.address ?? '--',
          ),
          _buildRow(
            context,
            'shop_management.field_phone'.tr(),
            shop.phone ?? '--',
          ),
          _buildRow(
            context,
            'shop_management.field_email'.tr(),
            shop.email ?? '--',
          ),
          _buildRow(
            context,
            'shop_management.field_status'.tr(),
            null,
            trailing: Align(
              alignment: Alignment.centerRight,
              child: ShopStatusBadge(shop: shop),
            ),
          ),
          _buildRow(
            context,
            'shop_management.field_created_at'.tr(),
            DateTimeUtils.formatDateFromDT(shop.createdAt) ?? '--',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String? value, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.neutral5),
            ),
          ),
          Expanded(
            child: trailing ??
                Text(
                  value ?? '--',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
