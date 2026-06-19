part of '../../views/shop_home_v2.dart';

class _TopCards extends StatelessWidget {
  const _TopCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _BalanceCard()),
        AppSpacing.horizontal(14),
        const Expanded(child: _PointCard()),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(14, 11, 8, 9),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            bottom: -4,
            child: Image.asset(
              ImagePath.shopHomeV2Wallet,
              width: 66,
              height: 62,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PrimaryText(
                    'Số dư khả dụng',
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: Colors.white.withAlpha(235),
                      fontSize: 13,
                    ),
                  ),
                  AppSpacing.horizontal(5),
                  const Icon(
                    Icons.visibility_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
              AppSpacing.vertical(6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: PrimaryText(
                  '2.560.000đ',
                  style: AppTextStyles.titleXXLarge.copyWith(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 26,
                width: 82,
                margin: const EdgeInsets.only(left: 2, bottom: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDimensions.mediumBorderRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      'Rút tiền',
                      style: AppTextStyles.labelXSmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                    AppSpacing.horizontal(5),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(13, 10, 10, 7),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        border: Border.all(color: AppColors.shopHomeV2LightBorder, width: 0.8),
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -2,
            top: 25,
            child: Image.asset(
              ImagePath.shopHomeV2Medal,
              width: 38,
              height: 38,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                'Tích điểm',
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: AppColors.neutral4,
                  fontSize: 12,
                ),
              ),
              AppSpacing.vertical(3),
              PrimaryText(
                '2.350',
                style: AppTextStyles.titleXXLarge.copyWith(
                  color: AppColors.shopHomeV2MerchantBrown,
                  fontSize: 25,
                  height: 1,
                ),
              ),
              AppSpacing.vertical(4),
              Row(
                children: [
                  PrimaryText(
                    'Hạng Vàng',
                    style: AppTextStyles.labelXSmall.copyWith(
                      color: AppColors.shopHomeV2MerchantBrown,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.shopHomeV2MerchantBrown,
                    size: 16,
                  ),
                ],
              ),
              AppSpacing.vertical(4),
              PrimaryText(
                'Còn 650 điểm để lên Kim Cương',
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyXXSmall.copyWith(
                  color: AppColors.neutral5,
                  fontSize: 8.5,
                  height: 1,
                ),
              ),
              AppSpacing.vertical(3),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: const LinearProgressIndicator(
                  value: 0.76,
                  minHeight: 5,
                  color: AppColors.primary,
                  backgroundColor: AppColors.shopHomeV2ProgressBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        border: Border.all(color: AppColors.shopHomeV2LightBorder, width: 0.8),
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: Row(
        children: [
          _QuickAction(
            label: 'Đơn hàng',
            color: AppColors.primary,
            assetPath: ImagePath.shopHomeV2IconOrder,
          ),
          _QuickAction(
            label: 'Tích điểm',
            color: AppColors.shopHomeV2QuickActionGreen,
            assetPath: ImagePath.shopHomeV2IconPointsFromRef,
          ),
          _QuickAction(
            label: 'Ưu đãi',
            color: AppColors.shopHomeV2QuickActionOffer,
            assetPath: ImagePath.shopHomeV2IconOffer,
          ),
          _QuickAction(
            label: 'Số dư',
            color: AppColors.shopHomeV2QuickActionWallet,
            assetPath: ImagePath.shopHomeV2IconWallet,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.color,
    required this.assetPath,
    this.badge,
  });

  final String label;
  final Color color;
  final String assetPath;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SizedBox.square(
                    dimension: 38,
                    child: Image.asset(assetPath, fit: BoxFit.contain),
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  right: -2,
                  top: -7,
                  child: Container(
                    width: 23,
                    height: 23,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: PrimaryText(
                      badge!,
                      style: AppTextStyles.labelXSmall.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          PrimaryText(
            label,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelXSmall.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
