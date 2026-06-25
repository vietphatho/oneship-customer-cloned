import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_bloc.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_filter.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_state.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_bank_account.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_summary_stats.dart';

class VendorWalletPage extends StatefulWidget {
  const VendorWalletPage({super.key});

  @override
  State<VendorWalletPage> createState() => _VendorWalletPageState();
}

class _VendorWalletPageState extends State<VendorWalletPage> {
  final VendorStatsBloc _statsBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _statsBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral9,
      appBar: PrimaryAppBar(title: 'vendor_wallet.title'.tr()),
      body: BlocBuilder<VendorStatsBloc, VendorStatsState>(
        bloc: _statsBloc,
        builder: (context, state) {
          final stats = state.stats;

          if (state.isLoading && stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isError && stats == null) {
            return Center(child: PrimaryEmptyData(onRetry: _retry));
          }

          if (stats == null || state.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppDimensions.mediumPaddingAll,
                children: [
                  const _VendorWalletFilters(),
                  AppSpacing.vertical(AppDimensions.largeSpacing),
                  const SizedBox(height: 180, child: PrimaryEmptyData()),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.mediumSpacing,
                AppDimensions.mediumSpacing,
                AppDimensions.mediumSpacing,
                AppDimensions.safeBottomSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WalletBalanceCard(balance: 0),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  const _VendorWalletFilters(),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  _VendorWalletSummary(stats: stats),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  _VendorStatsChart(stats: stats),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  WalletSummaryStats(
                    totalWithdrawn: 0,
                    lastWithdrawnAmount: 0,
                    lastWithdrawnDate: "--",
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  const WalletBankAccount(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    await _statsBloc.refresh();
  }

  void _retry() {
    _statsBloc.init(forceRefresh: true);
  }
}

class _VendorWalletFilters extends StatelessWidget {
  const _VendorWalletFilters();

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<VendorStatsBloc>();

    return BlocBuilder<VendorStatsBloc, VendorStatsState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.filter != current.filter ||
          previous.startDate != current.startDate ||
          previous.endDate != current.endDate,
      builder: (context, state) {
        return PrimaryPanel(
          padding: AppDimensions.mediumPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                'vendor_wallet.filters.title'.tr(),
                style: AppTextStyles.labelMedium,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  Expanded(
                    child: _FilterButton(
                      label: 'vendor_wallet.filters.this_week'.tr(),
                      isSelected: state.filter == VendorStatsFilter.thisWeek,
                      onPressed: () =>
                          bloc.changeFilter(VendorStatsFilter.thisWeek),
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                  Expanded(
                    child: _FilterButton(
                      label: 'vendor_wallet.filters.this_month'.tr(),
                      isSelected: state.filter == VendorStatsFilter.thisMonth,
                      onPressed: () =>
                          bloc.changeFilter(VendorStatsFilter.thisMonth),
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.xSmallSpacing),
              PrimaryButton.iconOutlined(
                label: _rangeLabel(state),
                height: AppDimensions.smallHeightButton,
                icon: const Icon(Icons.date_range_rounded),
                onPressed: () => _selectRange(context, bloc, state),
              ),
            ],
          ),
        );
      },
    );
  }

  String _rangeLabel(VendorStatsState state) {
    final start = DateTimeUtils.formatDateTime(
      state.startDate,
      format: Constants.defaultDateFormat,
    );
    final end = DateTimeUtils.formatDateTime(
      state.endDate,
      format: Constants.defaultDateFormat,
    );
    return '$start - $end';
  }

  Future<void> _selectRange(
    BuildContext context,
    VendorStatsBloc bloc,
    VendorStatsState state,
  ) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate,
      ),
    );
    if (range == null) return;

    bloc.changeCustomRange(startDate: range.start, endDate: range.end);
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return PrimaryButton.filled(
        label: label,
        height: AppDimensions.smallHeightButton,
        onPressed: onPressed,
      );
    }

    return PrimaryButton.outlined(
      label: label,
      height: AppDimensions.smallHeightButton,
      onPressed: onPressed,
    );
  }
}

class _VendorWalletSummary extends StatelessWidget {
  const _VendorWalletSummary({required this.stats});

  final VendorStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.monetization_on_rounded,
                color: AppColors.green,
                label: 'vendor_stats.cod_amount'.tr(),
                value: Utils.formatCurrencyWithUnit(stats.totalCodAmount),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: _SummaryCard(
                icon: Icons.local_shipping_rounded,
                color: AppColors.shopHomeV2StatsGold,
                label: 'vendor_stats.delivery_fee'.tr(),
                value: Utils.formatCurrencyWithUnit(
                  stats.totalDeliveryFeeAmount,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.inventory_2_rounded,
                color: AppColors.primary,
                label: 'vendor_stats.total_orders'.tr(),
                value: stats.orderCount.toString(),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: _SummaryCard(
                icon: Icons.check_circle_rounded,
                color: AppColors.successForeground,
                label: 'vendor_stats.delivered_orders'.tr(),
                value: stats.deliveredCount.toString(),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.assignment_return_rounded,
                color: AppColors.error,
                label: 'vendor_stats.returned_orders'.tr(),
                value: stats.returnedCount.toString(),
              ),
            ),
            AppSpacing.horizontal(AppDimensions.smallSpacing),
            Expanded(
              child: _SummaryCard(
                icon: Icons.trending_up_rounded,
                color: AppColors.shopHomeV2StatsPurple,
                label: 'vendor_stats.success_rate'.tr(),
                value: _formatPercent(stats.successRate),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPercent(double value) {
    return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}%';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDarkMode
        ? AppColors.surfaceDark
        : AppColors.background;
    final valueColor = isDarkMode
        ? AppColors.onSurfaceDark
        : AppColors.neutral1;
    final labelColor = isDarkMode
        ? AppColors.onSurfaceVariantDark
        : AppColors.neutral5;

    return PrimaryPanel(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      backgroundColor: surfaceColor,
      borderColor: color.withAlpha(isDarkMode ? 58 : 36),
      constraints: const BoxConstraints(minHeight: 96),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    color.withAlpha(isDarkMode ? 44 : 2),
                    surfaceColor,
                    surfaceColor,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: AppDimensions.smallSpacing,
            right: AppDimensions.smallSpacing,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withAlpha(isDarkMode ? 34 : 18),
                borderRadius: AppDimensions.largeBorderRadius,
              ),
              child: SizedBox(
                width: AppDimensions.xLargeSpacing,
                height: AppDimensions.xLargeSpacing,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.smallSpacing,
              AppDimensions.smallSpacing,
              AppDimensions.smallSpacing,
              AppDimensions.xSmallSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.withAlpha(isDarkMode ? 48 : 30),
                        borderRadius: AppDimensions.mediumBorderRadius,
                        border: Border.all(
                          color: color.withAlpha(isDarkMode ? 74 : 46),
                          width: AppDimensions.mediumBorderStroke,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppDimensions.xxSmallSpacing,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: AppDimensions.smallIconSize,
                        ),
                      ),
                    ),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    Expanded(
                      child: PrimaryText(
                        label,
                        style: AppTextStyles.labelXSmall,
                        color: labelColor,
                        maxLine: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: PrimaryText(
                    value,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLine: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorStatsChart extends StatelessWidget {
  const _VendorStatsChart({required this.stats});

  final VendorStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VendorStatsLineChart(
          title: 'vendor_wallet.chart.delivery_fee'.tr(),
          stats: stats,
          valueBuilder: (item) => item.totalDeliveryFeeAmount,
        ),
        AppSpacing.vertical(AppDimensions.smallSpacing),
        _VendorStatsLineChart(
          title: 'vendor_wallet.chart.cod'.tr(),
          stats: stats,
          valueBuilder: (item) => item.totalCodAmount,
        ),
      ],
    );
  }
}

class _VendorStatsLineChart extends StatelessWidget {
  const _VendorStatsLineChart({
    required this.title,
    required this.stats,
    required this.valueBuilder,
  });

  final String title;
  final VendorStats stats;
  final double Function(DailyVendorStat item) valueBuilder;

  @override
  Widget build(BuildContext context) {
    return PrimaryPanel(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryText(title, style: AppTextStyles.labelMedium),
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          SizedBox(
            height: 220,
            child: stats.dailyStats.isEmpty
                ? const Center(child: PrimaryEmptyData())
                : LineChart(
                    _chartData,
                    transformationConfig: FlTransformationConfig(
                      scaleAxis: FlScaleAxis.horizontal,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  LineChartData get _chartData {
    final spots = stats.dailyStats.mapIndexed((index, item) {
      return FlSpot(index.toDouble(), valueBuilder(item));
    }).toList();
    final maxY = spots
        .map((spot) => spot.y)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: 0,
      maxY: maxY == 0 ? 1 : maxY * 1.2,
      clipData: const FlClipData.vertical(),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: AppColors.neutral8, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                child: PrimaryText(
                  _compactNumber(value),
                  style: AppTextStyles.bodyXXSmall,
                  color: AppColors.neutral4,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: _bottomInterval.toDouble(),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= stats.dailyStats.length) {
                return const SizedBox();
              }
              return SideTitleWidget(
                meta: meta,
                child: PrimaryText(
                  DateFormat('dd/MM').format(stats.dailyStats[index].statDate),
                  style: AppTextStyles.bodyXXSmall,
                  color: AppColors.neutral4,
                ),
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                Utils.formatCurrencyWithUnit(spot.y),
                AppTextStyles.labelSmall.copyWith(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: AppColors.primary,
          isCurved: true,
          curveSmoothness: 0.3,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 0,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withAlpha(32),
          ),
        ),
      ],
    );
  }

  int get _bottomInterval {
    final length = stats.dailyStats.length;
    if (length <= 7) return 1;
    if (length <= 15) return 2;
    return 5;
  }

  String _compactNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(0)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}
