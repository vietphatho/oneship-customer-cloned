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
    final bloc = getIt.get<VendorStatsBloc>();

    return BlocBuilder<VendorStatsBloc, VendorStatsState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.statsResource != current.statsResource,
      builder: (context, state) {
        final stats = state.stats;

        if (state.isLoading && stats == null) {
          return const _StatsPanelFrame(
            child: SizedBox(
              height: 92,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state.isError && stats == null) {
          return _StatsPanelFrame(
            child: SizedBox(
              height: 92,
              child: Center(
                child: PrimaryButton.outlined(
                  label: 'retry'.tr(),
                  onPressed: () => bloc.init(forceRefresh: true),
                ),
              ),
            ),
          );
        }

        if (stats == null || state.isEmpty) {
          return _StatsPanelFrame(
            child: SizedBox(
              height: 92,
              child: Center(child: PrimaryText('vendor_stats.empty'.tr())),
            ),
          );
        }

        return _StatsPanelFrame(
          child: Column(
            children: [
              Row(
                children: [
                  _StatItem(
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.primary,
                    value: stats.orderCount.toString(),
                    label: 'vendor_stats.total_orders'.tr(),
                  ),
                  _StatItem(
                    icon: Icons.check_circle_rounded,
                    color: AppColors.successForeground,
                    value: stats.deliveredCount.toString(),
                    label: 'vendor_stats.delivered_orders'.tr(),
                  ),
                  _StatItem(
                    icon: Icons.assignment_return_rounded,
                    color: AppColors.error,
                    value: stats.returnedCount.toString(),
                    label: 'vendor_stats.returned_orders'.tr(),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  _StatItem(
                    icon: Icons.trending_up_rounded,
                    color: AppColors.shopHomeV2StatsPurple,
                    value: Utils.formatPercent(stats.successRate),
                    label: 'vendor_stats.success_rate'.tr(),
                  ),
                  _StatItem(
                    icon: Icons.local_shipping_rounded,
                    color: AppColors.shopHomeV2StatsGold,
                    value: Utils.formatCompactCurrency(
                      stats.totalDeliveryFeeAmount,
                    ),
                    label: 'vendor_stats.delivery_fee'.tr(),
                  ),
                  _StatItem(
                    icon: Icons.monetization_on_rounded,
                    color: AppColors.green,
                    value: Utils.formatCompactCurrency(stats.totalCodAmount),
                    label: 'vendor_stats.cod_amount'.tr(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsPanelFrame extends StatelessWidget {
  const _StatsPanelFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.smallSpacing,
        horizontal: AppDimensions.xxSmallSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.largeBorderRadius,
        boxShadow: [PrimaryBoxShadows.defaultShadow],
      ),
      child: child,
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
