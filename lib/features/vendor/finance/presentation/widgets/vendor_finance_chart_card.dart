import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/widgets/vendor_finance_chart_painter.dart';

class VendorFinanceChartsSection extends StatelessWidget {
  const VendorFinanceChartsSection({super.key, required this.items});

  final List<DailyBreakdownEntity> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final charts = [
          VendorFinanceChartCard(
            title: 'cod_trend'.tr(),
            label: 'chart_money_label'.tr(
              namedArgs: {'label': 'cod_collection'.tr()},
            ),
            metric: VendorFinanceChartMetric.cod,
            items: items,
          ),
          VendorFinanceChartCard(
            title: 'delivery_fee_trend'.tr(),
            label: 'chart_money_label'.tr(
              namedArgs: {'label': 'delivery_fee_title'.tr()},
            ),
            metric: VendorFinanceChartMetric.deliveryFee,
            items: items,
          ),
        ];

        if (constraints.maxWidth >= 640) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: charts.first),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              Expanded(child: charts.last),
            ],
          );
        }

        return Column(
          children: [
            charts.first,
            AppSpacing.vertical(AppDimensions.smallSpacing),
            charts.last,
          ],
        );
      },
    );
  }
}

class VendorFinanceChartCard extends StatelessWidget {
  const VendorFinanceChartCard({
    super.key,
    required this.title,
    required this.label,
    required this.metric,
    required this.items,
  });

  final String title;
  final String label;
  final VendorFinanceChartMetric metric;
  final List<DailyBreakdownEntity> items;

  @override
  Widget build(BuildContext context) {
    return _ChartSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(title, style: AppTextStyles.labelXSmall),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _ChartLegend(color: metric.color, label: label),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          SizedBox(
            height: VendorFinanceChartPainter.chartHeight,
            width: double.infinity,
            child: items.isEmpty
                ? Center(
                    child: PrimaryText(
                      'no_daily_data'.tr(),
                      style: AppTextStyles.bodyXSmall,
                      color: AppColors.grey500,
                      textAlign: TextAlign.center,
                    ),
                  )
                : CustomPaint(
                    painter: VendorFinanceChartPainter(
                      items: items,
                      metric: metric,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChartSurface extends StatelessWidget {
  const _ChartSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.largeBorderRadius,
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(padding: AppDimensions.smallPaddingAll, child: child),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: AppDimensions.xSmallSpacing,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        AppSpacing.horizontal(AppDimensions.xxSmallSpacing),
        PrimaryText(
          label,
          style: AppTextStyles.bodyXXSmall,
          color: AppColors.grey600,
        ),
      ],
    );
  }
}
