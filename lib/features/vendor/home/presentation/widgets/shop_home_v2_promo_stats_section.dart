part of '../views/vendor_home_page.dart';

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppDimensions.largeBorderRadius,
      child: SizedBox(
        height: 86,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ImagePath.shopHomeV2RefPromoBannerHd,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            Positioned(
              right: 8,
              bottom: 6,
              child: Material(
                color: Colors.white,
                borderRadius: AppDimensions.largeBorderRadius,
                child: InkWell(
                  borderRadius: AppDimensions.largeBorderRadius,
                  onTap: () {},
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PrimaryText(
                          'Khám phá ngay',
                          style: AppTextStyles.labelXSmall.copyWith(
                            color: AppColors.shopHomeV2PromoButtonText,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        AppSpacing.horizontal(3),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: Row(
        children: const [
          _StatItem(
            icon: Icons.inventory_2_rounded,
            color: AppColors.primary,
            value: '128',
            label: 'Tổng đơn hàng',
          ),
          _StatItem(
            icon: Icons.check_circle_rounded,
            color: AppColors.successForeground,
            value: '102',
            label: 'Đơn hoàn thành',
          ),
          _StatItem(
            icon: Icons.trending_up_rounded,
            color: AppColors.shopHomeV2StatsPurple,
            value: '79%',
            label: 'Tỷ lệ hoàn thành',
          ),
          _StatItem(
            icon: Icons.monetization_on_rounded,
            color: AppColors.shopHomeV2StatsGold,
            value: '12.5Mđ',
            label: 'Tổng đã giao',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withAlpha(24),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          AppSpacing.vertical(4),
          PrimaryText(
            value,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelXSmall.copyWith(fontSize: 15),
          ),
          PrimaryText(
            label,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyXXSmall.copyWith(
              color: AppColors.neutral5,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
