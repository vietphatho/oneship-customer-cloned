import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

class ShopCard extends StatelessWidget {
  final int index;
  final ShopEntity shop;

  const ShopCard({super.key, required this.index, required this.shop});

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    PrimaryText(
                      "#$index. ",
                      style: AppTextStyles.bodySmall,
                      color: AppColors.secondary,
                    ),
                    PrimaryText(shop.shopName, style: AppTextStyles.titleLarge),
                  ],
                ),
              ),
              // ShopStatusBadge(shop: shop),
            ],
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          _buildRow(
            context,
            'shop_management.field_address'.tr(),
            shop.profile?.fullAddress,
          ),
          _buildRow(
            context,
            'shop_management.field_phone'.tr(),
            shop.profile?.phone,
          ),
          _buildRow(
            context,
            'shop_management.field_email'.tr(),
            shop.profile?.email,
          ),
          _buildRow(
            context,
            'shop_management.field_created_at'.tr(),
            DateTimeUtils.formatDateFromDT(shop.createdAt) ?? '--',
          ),
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
      padding: EdgeInsets.symmetric(vertical: AppDimensions.xxxSmallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            label,
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral6,
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Expanded(
            child:
                trailing ??
                PrimaryText(
                  value ?? '--',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium,
                  color: AppColors.neutral2,
                ),
          ),
        ],
      ),
    );
  }
}
