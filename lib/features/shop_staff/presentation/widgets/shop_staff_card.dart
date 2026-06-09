import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';

class ShopStaffCard extends StatelessWidget {
  const ShopStaffCard({
    super.key,
    required this.staff,
    this.onViewDetails,
  });

  final ShopStaffEntity staff;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      onTap: onViewDetails,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const PrimaryAssetAvatar(
            image: ImagePath.shopHomeAvatar,
            backgroundImage: ImagePath.shopHomeAvatarBackground,
            radius: 34,
          ),
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  staff.displayName,
                  style: AppTextStyles.titleSmall,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                Row(
                  children: [
                    Flexible(
                      child: PrimaryText(
                        staff.userLogin,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        color: AppColors.neutral4,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    const PrimaryText('•', color: AppColors.neutral5),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    Flexible(
                      child: PrimaryText(
                        staff.userPhone,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        color: AppColors.neutral4,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
                PrimaryText(
                  staff.userEmail,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  color: AppColors.neutral4,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          Container(
            width: AppDimensions.xSmallSpacing,
            height: AppDimensions.xSmallSpacing,
            decoration: BoxDecoration(
              color: staff.isActive
                  ? AppColors.successForeground
                  : AppColors.errorForeground,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.horizontal(AppDimensions.smallSpacing),
          IconButton(
            onPressed: onViewDetails,
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.neutral5,
            iconSize: 22,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
