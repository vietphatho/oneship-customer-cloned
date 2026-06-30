import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class FinanceOverviewTabView extends StatefulWidget {
  const FinanceOverviewTabView({super.key});

  @override
  State<FinanceOverviewTabView> createState() => _FinanceOverviewTabViewState();
}

class _FinanceOverviewTabViewState extends State<FinanceOverviewTabView> {
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceOverviewBloc, FinanceOverviewState>(
      bloc: _financeOverviewBloc,
      builder: (context, state) {
        if (state.shopFinancialData.state == Result.error) {
          return PrimaryEmptyData(
            onRetry: () => _financeOverviewBloc.fetchFinancialData(
              filter: state.financeFilter,
              startDate: state.startDate,
              endDate: state.endDate,
              shopId: _shopBloc.state.currentShop?.shopId ?? "",
              requestSource: FinanceRequestSource.page,
            ),
          );
        }

        final finance = state.shopFinancialData.data ?? FinanceEntity();
        final currentShop = _shopBloc.state.currentShop;
        final shopDetail =
            (_shopBloc.state.shopsResource.data?.items ?? const [])
                .firstWhereOrNull((shop) => shop.id == currentShop?.shopId);
        final shopAddress = currentShop?.address?.trim().isNotEmpty == true
            ? currentShop!.address!
            : shopDetail?.profile?.fullAddress?.trim().isNotEmpty == true
            ? shopDetail!.profile!.fullAddress!
            : 'no_shop_address'.tr();
        return ColoredBox(
          color: AppColors.financePageBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryCards(finance: finance),
                const SizedBox(height: 16),
                _ChartCard(items: finance.dailyBreakdown ?? const []),
                const SizedBox(height: 16),
                _DetailsGrid(finance: finance),
                const SizedBox(height: 16),
                _DailySummaryCard(items: finance.dailyBreakdown ?? const []),
                const SizedBox(height: 16),
                _RegionSummaryCard(
                  items: [
                    _RegionSummaryItem(
                      address: shopAddress,
                      orderCount: finance.orderCount ?? 0,
                      amount: finance.totalOut ?? 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.finance});

  final FinanceEntity finance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'remain_balance'.tr(),
                  value: Utils.formatCurrencyWithUnit(finance.netAmount),
                  color: AppColors.primaryDark,
                  icon: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primaryDark,
                    size: 25,
                  ),
                  iconBackgroundColor: AppColors.financeBalanceBackground,
                  decoration: const _WalletMetricDecoration(
                    color: AppColors.financeBalanceBackground,
                    foregroundColor: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'cod_collection_amount'.tr(),
                  value: Utils.formatCurrencyWithUnit(finance.codCollected),
                  color: AppColors.blue600,
                  icon: const Icon(
                    Icons.crop_free_rounded,
                    color: AppColors.blue600,
                    size: 25,
                  ),
                  iconBackgroundColor: AppColors.financeCodBackground,
                  decoration: const _ChartMetricDecoration(
                    color: AppColors.financeCodBackground,
                    foregroundColor: AppColors.blue600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'total_expense'.tr(),
                  value: Utils.formatCurrencyWithUnit(finance.totalOut),
                  color: AppColors.error,
                  icon: const Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.error,
                    size: 25,
                  ),
                  iconBackgroundColor: AppColors.financeExpenseBackground,
                  decoration: const _RingMetricDecoration(
                    color: AppColors.financeExpenseBackground,
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'discount_1'.tr(),
                  value: Utils.formatCurrencyWithUnit(finance.discountAmount),
                  color: AppColors.secondary,
                  icon: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                  iconBackgroundColor: AppColors.financeDiscountBackground,
                  decoration: const _TagMetricDecoration(
                    color: AppColors.financeDiscountBackground,
                    foregroundColor: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.iconBackgroundColor,
    required this.decoration,
  });

  final String title;
  final String value;
  final Color color;
  final Widget icon;
  final Color iconBackgroundColor;
  final Widget decoration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: _Surface(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 126,
          child: Stack(
            children: [
              Positioned(right: -6, bottom: -4, child: decoration),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: iconBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: icon,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 26,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletMetricDecoration extends StatelessWidget {
  const _WalletMetricDecoration({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 86,
      child: CustomPaint(
        painter: _WalletMetricPainter(
          color: color,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

class _ChartMetricDecoration extends StatelessWidget {
  const _ChartMetricDecoration({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 86,
      child: CustomPaint(
        painter: _ChartMetricPainter(
          color: color,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

class _RingMetricDecoration extends StatelessWidget {
  const _RingMetricDecoration({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 86,
      child: CustomPaint(
        painter: _RingMetricPainter(
          color: color,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

class _TagMetricDecoration extends StatelessWidget {
  const _TagMetricDecoration({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 86,
      child: CustomPaint(
        painter: _TagMetricPainter(
          color: color,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

class _WalletMetricPainter extends CustomPainter {
  const _WalletMetricPainter({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = color.withAlpha(135);
    final walletPaint = Paint()
      ..color = foregroundColor.withAlpha(28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.26,
          size.height * 0.24,
          size.width,
          size.height,
        ),
        const Radius.circular(28),
      ),
      backgroundPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.36, size.height * 0.34, 52, 36),
        const Radius.circular(9),
      ),
      walletPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.66, size.height * 0.45, 20, 12),
        const Radius.circular(6),
      ),
      walletPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WalletMetricPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.foregroundColor != foregroundColor;
}

class _ChartMetricPainter extends CustomPainter {
  const _ChartMetricPainter({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = color.withAlpha(135);
    final barPaint = Paint()
      ..color = foregroundColor.withAlpha(55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.12,
        size.height * 0.18,
        size.width * 1.35,
        size.height * 1.35,
      ),
      math.pi,
      math.pi / 2,
      true,
      backgroundPaint,
    );

    final left = size.width * 0.52;
    for (var index = 0; index < 4; index++) {
      final x = left + index * 16;
      final top = size.height * (0.74 - index * 0.14);
      canvas.drawLine(Offset(x, size.height + 8), Offset(x, top), barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartMetricPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.foregroundColor != foregroundColor;
}

class _RingMetricPainter extends CustomPainter {
  const _RingMetricPainter({
    required this.color,
    required this.foregroundColor,
  });

  final Color color;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = color.withAlpha(135);
    final ringPaint = Paint()
      ..color = foregroundColor.withAlpha(35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.20,
          size.height * 0.28,
          size.width,
          size.height,
        ),
        const Radius.circular(30),
      ),
      backgroundPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.70),
      42,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingMetricPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.foregroundColor != foregroundColor;
}

class _TagMetricPainter extends CustomPainter {
  const _TagMetricPainter({required this.color, required this.foregroundColor});

  final Color color;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = color.withAlpha(135);
    final tagPaint = Paint()..color = foregroundColor.withAlpha(32);
    final detailPaint = Paint()
      ..color = foregroundColor.withAlpha(65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.22,
        size.width * 1.28,
        size.height * 1.25,
      ),
      math.pi,
      math.pi / 2,
      true,
      backgroundPaint,
    );

    canvas.save();
    canvas.translate(size.width * 0.55, size.height * 0.50);
    canvas.rotate(-0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-24, -22, 54, 46),
        const Radius.circular(12),
      ),
      tagPaint,
    );
    canvas.drawCircle(
      const Offset(14, -8),
      4,
      detailPaint..style = PaintingStyle.fill,
    );
    detailPaint.style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(-10, 12), const Offset(12, 12), detailPaint);
    canvas.drawLine(const Offset(-6, 3), const Offset(-6, 20), detailPaint);
    canvas.drawLine(const Offset(8, 3), const Offset(8, 20), detailPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TagMetricPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.foregroundColor != foregroundColor;
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.items});
  final List<DailyBreakdownEntity> items;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'cod_and_delivery_fee'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: AppColors.grey200),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         'by_day'.tr(),
              //         style: const TextStyle(
              //           fontSize: 10,
              //           color: AppColors.grey600,
              //         ),
              //       ),
              //       SizedBox(width: 4),
              //       _FinanceAssetIcon(
              //         asset: 'assets/icons/finance_chevron_down.svg',
              //         color: AppColors.grey500,
              //         size: 12,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          Row(
            children: [
              _Legend(
                color: AppColors.green600,
                label: 'chart_money_label'.tr(
                  namedArgs: {'label': 'cod_collection'.tr()},
                ),
              ),
              const SizedBox(width: 20),
              _Legend(
                color: AppColors.primary,
                label: 'chart_money_label'.tr(
                  namedArgs: {'label': 'delivery_fee_title'.tr()},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'no_daily_data'.tr(),
                      style: const TextStyle(color: AppColors.grey500),
                    ),
                  )
                : CustomPaint(painter: _FinanceChartPainter(items)),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.grey600),
        ),
      ],
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.finance});
  final FinanceEntity finance;

  @override
  Widget build(BuildContext context) {
    final successfulOrderFee =
        (finance.deliveryFee ?? 0) +
        (finance.deliveryFeeVat ?? 0) +
        (finance.surchargeFee ?? 0) +
        (finance.surchargeVat ?? 0);
    final returnedOrderFee =
        (finance.returnForwardFee ?? 0) +
        (finance.returnForwardFeeVat ?? 0) +
        (finance.returnDeliveryFee ?? 0) +
        (finance.returnDeliveryFeeVat ?? 0) +
        (finance.returnSurchargeFee ?? 0) +
        (finance.returnSurchargeVat ?? 0);
    final discountRefund =
        (finance.discountAmount ?? 0) +
        (finance.rebateAmount ?? 0) +
        (finance.adjustmentAmount ?? 0);

    return Column(
      children: [
        _FeeBreakdownCard(
          title: 'successful_order_fee'.tr(),
          color: AppColors.primary,
          icon: const Icon(
            Icons.attach_money_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          iconBackgroundColor: AppColors.financeBalanceBackground,
          decoration: const _WalletMetricDecoration(
            color: AppColors.financeBalanceBackground,
            foregroundColor: AppColors.primary,
          ),
          rows: [
            _FeeBreakdownRow(
              label: 'shipping_fee'.tr(),
              amount: finance.deliveryFee,
            ),
            _FeeBreakdownRow(
              label: 'shipping_fee_VAT'.tr(),
              amount: finance.deliveryFeeVat,
            ),
            _FeeBreakdownRow(
              label: 'surcharge'.tr(),
              amount: finance.surchargeFee,
            ),
            _FeeBreakdownRow(
              label: 'surcharge_vat'.tr(),
              amount: finance.surchargeVat,
            ),
          ],
          totalAmount: successfulOrderFee,
        ),
        const SizedBox(height: 16),
        _FeeBreakdownCard(
          title: 'return_order_fee'.tr(),
          color: AppColors.blue600,
          icon: const Icon(
            Icons.settings_backup_restore_rounded,
            color: AppColors.blue600,
            size: 20,
          ),
          iconBackgroundColor: AppColors.financeCodBackground,
          decoration: const _WalletMetricDecoration(
            color: AppColors.financeCodBackground,
            foregroundColor: AppColors.blue600,
          ),
          rows: [
            _FeeBreakdownRow(
              label: 'forward_shipping_fee'.tr(),
              amount: finance.returnForwardFee,
            ),
            _FeeBreakdownRow(
              label: 'forward_shipping_vat'.tr(),
              amount: finance.returnForwardFeeVat,
            ),
            _FeeBreakdownRow(
              label: 'return_shipping_fee'.tr(),
              amount: finance.returnDeliveryFee,
            ),
            _FeeBreakdownRow(
              label: 'return_shipping_vat'.tr(),
              amount: finance.returnDeliveryFeeVat,
            ),
            _FeeBreakdownRow(
              label: 'surcharge'.tr(),
              amount: finance.returnSurchargeFee,
            ),
            _FeeBreakdownRow(
              label: 'surcharge_vat'.tr(),
              amount: finance.returnSurchargeVat,
            ),
          ],
          totalAmount: returnedOrderFee,
        ),
        const SizedBox(height: 16),
        _FeeBreakdownCard(
          title: 'discount_refund'.tr(),
          color: AppColors.green600,
          icon: const Icon(
            Icons.discount_outlined,
            color: AppColors.green600,
            size: 20,
          ),
          iconBackgroundColor: AppColors.financeDiscountBackground,
          decoration: const _TagMetricDecoration(
            color: AppColors.financeDiscountBackground,
            foregroundColor: AppColors.green600,
          ),
          rows: [
            _FeeBreakdownRow(
              label: 'discount_1'.tr(),
              amount: finance.discountAmount,
              showPositiveSign: true,
            ),
            _FeeBreakdownRow(
              label: 'refund'.tr(),
              amount: finance.rebateAmount,
              showPositiveSign: true,
            ),
            _FeeBreakdownRow(
              label: 'adjustment'.tr(),
              amount: finance.adjustmentAmount,
              showPositiveSign: true,
            ),
          ],
          totalAmount: discountRefund,
          showPositiveSign: true,
        ),
      ],
    );
  }
}

class _FeeBreakdownCard extends StatelessWidget {
  const _FeeBreakdownCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.iconBackgroundColor,
    required this.decoration,
    required this.rows,
    required this.totalAmount,
    this.showPositiveSign = false,
  });

  final String title;
  final Color color;
  final Widget icon;
  final Color iconBackgroundColor;
  final Widget decoration;
  final List<_FeeBreakdownRow> rows;
  final int totalAmount;
  final bool showPositiveSign;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(right: 0, bottom: 0, child: decoration),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: icon,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                for (final row in rows) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.label,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatAmount(
                            row.amount ?? 0,
                            showPositiveSign: row.showPositiveSign,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: row.showPositiveSign
                                ? AppColors.green600
                                : AppColors.blue950,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                const Divider(height: 1, color: AppColors.grey200),
                const SizedBox(height: 16),
                Text(
                  'total'.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _formatAmount(
                    totalAmount,
                    showPositiveSign: showPositiveSign,
                  ),
                  style: TextStyle(
                    fontSize: 26,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount, {required bool showPositiveSign}) {
    final value = Utils.formatCurrencyWithUnit(amount);
    if (!showPositiveSign) return value;
    return '+$value';
  }
}

class _FeeBreakdownRow {
  const _FeeBreakdownRow({
    required this.label,
    required this.amount,
    this.showPositiveSign = false,
  });

  final String label;
  final int? amount;
  final bool showPositiveSign;
}

class _RegionSummaryCard extends StatelessWidget {
  const _RegionSummaryCard({required this.items});

  final List<_RegionSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items]
      ..sort((a, b) {
        final orderComparison = b.orderCount.compareTo(a.orderCount);
        if (orderComparison != 0) return orderComparison;
        return b.amount.compareTo(a.amount);
      });

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'top_delivery_regions'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.grey200),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'address'.tr(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 62,
                  child: Text(
                    'order_count_short'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'delivery_fee_total'.tr(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey200),
          for (final item in sortedItems) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 62,
                    child: Text(
                      'order_count_unit'.tr(
                        namedArgs: {'count': '${item.orderCount}'},
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      Utils.formatCurrencyWithUnit(item.amount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.grey200),
          ],
        ],
      ),
    );
  }
}

class _RegionSummaryItem {
  const _RegionSummaryItem({
    required this.address,
    required this.orderCount,
    required this.amount,
  });

  final String address;
  final int orderCount;
  final int amount;
}

class _DailySummaryCard extends StatefulWidget {
  const _DailySummaryCard({required this.items});
  final List<DailyBreakdownEntity> items;

  @override
  State<_DailySummaryCard> createState() => _DailySummaryCardState();
}

class _DailySummaryCardState extends State<_DailySummaryCard> {
  final Set<String> _expandedDates = {};

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.items.take(5).toList();
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'daily_statistics'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () => context.push(RouteName.financeDetailByDayPage),
                child: Text('view_all'.tr()),
              ),
            ],
          ),
          if (visibleItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'no_data_yet'.tr(),
                  style: const TextStyle(color: AppColors.grey500),
                ),
              ),
            )
          else
            for (final item in visibleItems) ...[
              const Divider(height: 1, color: AppColors.grey200),
              _DailySummaryItem(
                item: item,
                expanded: _expandedDates.contains(item.date),
                onTap: () => _toggleItem(item.date),
              ),
            ],
        ],
      ),
    );
  }

  void _toggleItem(String? date) {
    if (date == null) return;

    setState(() {
      if (_expandedDates.contains(date)) {
        _expandedDates.remove(date);
      } else {
        _expandedDates.add(date);
      }
    });
  }
}

class _DailySummaryItem extends StatelessWidget {
  const _DailySummaryItem({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final DailyBreakdownEntity item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final balanceColor = (item.netAmount ?? 0) < 0
        ? AppColors.primary
        : AppColors.green600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _FinanceAssetIcon(
                  asset: 'assets/icons/finance_calendar.svg',
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateTimeUtils.formatterString(item.date),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue950,
                    ),
                  ),
                ),
                Text(
                  Utils.formatCurrencyWithUnit(item.netAmount),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: balanceColor,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _DailySummaryChip(
                  label: 'cod_short'.tr(),
                  value: Utils.formatCurrencyWithUnit(item.codCollected),
                  valueColor: AppColors.green600,
                ),
                const SizedBox(width: 8),
                _DailySummaryChip(
                  label: 'order_count_short'.tr(),
                  value: '${item.orderCount ?? 0}',
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    _DailySummaryRow(
                      label: 'cod_collection_amount'.tr(),
                      value: Utils.formatCurrencyWithUnit(item.codCollected),
                      valueColor: AppColors.green600,
                    ),
                    _DailySummaryRow(
                      label: 'shipping_fee'.tr(),
                      value: Utils.formatCurrencyWithUnit(item.deliveryFee),
                    ),
                    _DailySummaryRow(
                      label: 'surcharge'.tr(),
                      value: Utils.formatCurrencyWithUnit(item.surchargeFee),
                    ),
                    _DailySummaryRow(
                      label: 'return_order_fee'.tr(),
                      value: Utils.formatCurrencyWithUnit(
                        item.totalReturnedFee,
                      ),
                    ),
                    _DailySummaryRow(
                      label: 'remain_balance'.tr(),
                      value: Utils.formatCurrencyWithUnit(item.netAmount),
                      valueColor: balanceColor,
                    ),
                    _DailySummaryRow(
                      label: 'successful_orders'.tr(),
                      value: '${item.orderCount ?? 0}',
                    ),
                    _DailySummaryRow(
                      label: 'returned_orders'.tr(),
                      value: '${item.returnedOrderCount ?? 0}',
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryChip extends StatelessWidget {
  const _DailySummaryChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.financePageBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.grey500),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.blue950,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryRow extends StatelessWidget {
  const _DailySummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.blue950,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.grey200),
      ],
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FinanceAssetIcon extends StatelessWidget {
  const _FinanceAssetIcon({
    required this.asset,
    required this.color,
    required this.size,
  });

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: _FinanceAssetIcon(
          asset: 'assets/icons/finance_status_check.svg',
          color: color,
          size: 10,
        ),
      ),
    );
  }
}

class _FinanceChartPainter extends CustomPainter {
  final List<DailyBreakdownEntity> items;

  _FinanceChartPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final paintCodLine = Paint()
      ..color = AppColors.green600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final paintFeeLine = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final paintCodDot = Paint()
      ..color = AppColors.green600
      ..style = PaintingStyle.fill;

    final paintFeeDot = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final paintDotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = AppColors.grey200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      color: AppColors.grey500,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    // 1. Calculate nice max values for left (COD) and right (Fee) Y-axes
    double maxCod = 0;
    double maxFee = 0;
    for (final item in items) {
      maxCod = math.max(maxCod, (item.codCollected ?? 0).toDouble());
      maxFee = math.max(maxFee, (item.totalOut ?? 0).toDouble());
    }

    // Process Left Axis (COD) max
    if (maxCod <= 0) {
      maxCod = 20000000; // 20M fallback
    } else {
      double division = maxCod / 4;
      double step = 1000000; // 1M step
      if (division > 10000000) {
        step = 5000000;
      } else if (division > 5000000) {
        step = 2000000;
      } else if (division > 2000000) {
        step = 1000000;
      } else if (division > 1000000) {
        step = 500000;
      } else if (division > 500000) {
        step = 200000;
      } else {
        step = 100000;
      }
      double roundedDivision = (division / step).ceil() * step;
      maxCod = roundedDivision * 4;
    }

    // Process Right Axis (Fee) max
    if (maxFee <= 0) {
      maxFee = 800000; // 800k fallback
    } else {
      double division = maxFee / 4;
      double step = 10000; // 10k step
      if (division > 100000) {
        step = 50000;
      } else if (division > 50000) {
        step = 20000;
      } else if (division > 20000) {
        step = 10000;
      } else if (division > 10000) {
        step = 5000;
      } else {
        step = 2000;
      }
      double roundedDivision = (division / step).ceil() * step;
      maxFee = roundedDivision * 4;
    }

    const double leftPadding = 40;
    const double rightPadding = 40;
    const double topPadding = 15;
    const double bottomPadding = 25;

    final double chartWidth = size.width - leftPadding - rightPadding;
    final double chartHeight = size.height - topPadding - bottomPadding;

    // Helper to format Y labels
    String formatYLabel(double val) {
      if (val == 0) return '0';
      if (val >= 1000000) {
        double m = val / 1000000;
        return '${m.toStringAsFixed(m % 1 == 0 ? 0 : 1)}M';
      } else if (val >= 1000) {
        double k = val / 1000;
        return '${k.toStringAsFixed(k % 1 == 0 ? 0 : 1)}K';
      }
      return val.toStringAsFixed(0);
    }

    // 2. Draw Y axis grid lines and labels
    const int gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final double y = topPadding + chartHeight * (1 - i / gridLines);

      // Draw grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        paintGrid,
      );

      // Left Y label (COD)
      final double codVal = maxCod * (i / gridLines);
      final leftTextPainter = TextPainter(
        text: TextSpan(text: formatYLabel(codVal), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      leftTextPainter.paint(
        canvas,
        Offset(
          leftPadding - leftTextPainter.width - 6,
          y - leftTextPainter.height / 2,
        ),
      );

      // Right Y label (Fee)
      final double feeVal = maxFee * (i / gridLines);
      final rightTextPainter = TextPainter(
        text: TextSpan(text: formatYLabel(feeVal), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      rightTextPainter.paint(
        canvas,
        Offset(size.width - rightPadding + 6, y - rightTextPainter.height / 2),
      );
    }

    // 3. Draw lines and points
    final Path pathCod = Path();
    final Path pathFee = Path();
    final List<Offset> pointsCod = [];
    final List<Offset> pointsFee = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final double codVal = (item.codCollected ?? 0).toDouble();
      final double feeVal = (item.totalOut ?? 0).toDouble();

      final double x = items.length > 1
          ? leftPadding + i * (chartWidth / (items.length - 1))
          : leftPadding + chartWidth / 2;

      final double yCod = topPadding + chartHeight * (1 - codVal / maxCod);
      final double yFee = topPadding + chartHeight * (1 - feeVal / maxFee);

      final offsetCod = Offset(x, yCod);
      final offsetFee = Offset(x, yFee);

      pointsCod.add(offsetCod);
      pointsFee.add(offsetFee);

      if (i == 0) {
        pathCod.moveTo(x, yCod);
        pathFee.moveTo(x, yFee);
      } else {
        pathCod.lineTo(x, yCod);
        pathFee.lineTo(x, yFee);
      }

      // X Label (Date)
      String dateText = '';
      if (item.date != null) {
        try {
          final dt = DateTime.parse(item.date!);
          dateText =
              '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
        } catch (_) {
          dateText = item.date!;
        }
      }
      final xTextPainter = TextPainter(
        text: TextSpan(text: dateText, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      xTextPainter.paint(
        canvas,
        Offset(x - xTextPainter.width / 2, topPadding + chartHeight + 6),
      );
    }

    // Draw the paths
    if (items.length > 1) {
      canvas.drawPath(pathCod, paintCodLine);
      canvas.drawPath(pathFee, paintFeeLine);
    }

    // Draw the circular dots at each data point
    for (int i = 0; i < items.length; i++) {
      // COD dots
      canvas.drawCircle(pointsCod[i], 4.5, paintDotBorder);
      canvas.drawCircle(pointsCod[i], 3.0, paintCodDot);

      // Fee dots
      canvas.drawCircle(pointsFee[i], 4.5, paintDotBorder);
      canvas.drawCircle(pointsFee[i], 3.0, paintFeeDot);
    }
  }

  @override
  bool shouldRepaint(covariant _FinanceChartPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}
