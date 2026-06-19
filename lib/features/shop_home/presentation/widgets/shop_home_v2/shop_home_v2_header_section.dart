part of '../../views/shop_home_v2.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 162,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -12,
            top: 36,
            child: Image.asset(
              ImagePath.shopHomeV2Market,
              width: 252,
              height: 96,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [PrimaryBoxShadows.defaultShadow],
                ),
                child: ClipOval(
                  child: Image.asset(
                    ImagePath.shopHomeV2AvatarReference,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppSpacing.horizontal(12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 118),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        'Xin chào, Hạnh! 👋',
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 17,
                          height: 1.05,
                        ),
                      ),
                      AppSpacing.vertical(9),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.shopHomeV2SoftOrangeBackground,
                          borderRadius: AppDimensions.mediumBorderRadius,
                        ),
                        child: PrimaryText(
                          'Tiểu thương',
                          style: AppTextStyles.labelXSmall.copyWith(
                            color: AppColors.shopHomeV2MerchantBrown,
                            fontSize: 12,
                            height: 1,
                          ),
                        ),
                      ),
                      AppSpacing.vertical(9),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          AppSpacing.horizontal(4),
                          Expanded(
                            child: PrimaryText(
                              'Chợ Bình Tây, Quận 6',
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyXSmall.copyWith(
                                color: AppColors.neutral4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.neutral4,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -2,
            top: 14,
            child: PrimaryIconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              size: 44,
              iconColor: AppColors.neutral1,
              backgroundColor: Colors.white,
              borderColor: Colors.transparent,
              borderRadius: AppDimensions.largeBorderRadius,
              showBadgeDot: true,
              boxShadow: [PrimaryBoxShadows.defaultShadow],
            ),
          ),
        ],
      ),
    );
  }
}


