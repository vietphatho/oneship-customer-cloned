import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_status.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_bloc.dart';

class VendorFinancePeriodDetailPage extends StatelessWidget {
  const VendorFinancePeriodDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorFinanceReconciliationBloc = getIt
        .get<VendorFinanceReconciliationBloc>();
    final periodDetail =
        vendorFinanceReconciliationBloc.state.periodDetailEntity.data;

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'period_detail'.tr(),
        titleColor: AppColors.blue950,
        centerTitle: false,
      ),
      backgroundColor: AppColors.financePageBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PeriodHeader(periodDetail: periodDetail),
            const SizedBox(height: 16),
            _MetricGrid(periodDetail: periodDetail),
            const SizedBox(height: 16),
            _buildPeriodInformation(periodDetail),
            const SizedBox(height: 16),
            _buildPayout(),
            const SizedBox(height: 16),
            _buildDailyBreakdown(periodDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodInformation(PeriodDetailEntity? periodDetail) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'period_information'.tr(),
            icon: 'assets/icons/finance_calendar.svg',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'period_type'.tr(),
            value: _periodTypeText(periodDetail?.periodType),
          ),
          _InfoRow(
            label: 'start_date'.tr(),
            value: DateTimeUtils.formatDateFromDT(periodDetail?.startedAt),
          ),
          _InfoRow(
            label: 'end_date'.tr(),
            value: DateTimeUtils.formatDateFromDT(periodDetail?.endedAt),
          ),
          _InfoRow(
            label: 'status'.tr(),
            trailing: PrimaryStatus(
              color:
                  periodDetail?.periodStatus.getStatusColor() ??
                  AppColors.primary,
              label: _statusText(periodDetail?.status),
            ),
          ),
          _InfoRow(
            label: 'adjustment'.tr(),
            value: Utils.formatCurrencyWithUnit(periodDetail?.totalAdjustment),
          ),
          _InfoRow(
            label: 'created_at'.tr(),
            value: DateTimeUtils.formatDateFromDT(periodDetail?.createdAt),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPayout() {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'payment_information'.tr(),
            icon: 'assets/icons/finance_wallet.svg',
          ),
          const SizedBox(height: 18),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'payment_information_empty'.tr(),
                style: const TextStyle(color: AppColors.grey500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBreakdown(PeriodDetailEntity? periodDetail) {
    final items = periodDetail?.dailyBreakdown ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'detail_by_day'.tr(),
            icon: 'assets/icons/finance_calendar.svg',
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                _DailyBreakdownTile(dailyEntity: items[index]),
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: AppColors.grey200),
            itemCount: items.length,
          ),
        ],
      ),
    );
  }

  String _periodTypeText(String? type) {
    return switch (type?.toLowerCase()) {
      'daily' => 'daily'.tr(),
      'weekly' => 'weekly'.tr(),
      'monthly' => 'monthly'.tr(),
      null || '' => '--',
      _ => type!,
    };
  }

  String _statusText(String? status) {
    return switch (status?.toLowerCase()) {
      'open' => 'open'.tr(),
      'locked' => 'locked'.tr(),
      'approved' => 'approved'.tr(),
      'cancelled' => 'cancelled'.tr(),
      null || '' => '--',
      _ => status!,
    };
  }
}

class _PeriodHeader extends StatelessWidget {
  const _PeriodHeader({required this.periodDetail});

  final PeriodDetailEntity? periodDetail;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.warningBackground,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/finance_calendar.svg',
              width: 26,
              height: 26,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  periodDetail?.periodCode ?? '--',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue950,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateTimeUtils.formatDateFromDT(periodDetail?.startedAt)} - ${DateTimeUtils.formatDateFromDT(periodDetail?.endedAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w600,
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.periodDetail});

  final PeriodDetailEntity? periodDetail;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        title: 'total_income'.tr(),
        value: Utils.formatCurrencyWithUnit(periodDetail?.totalIn),
        icon: 'assets/icons/finance_cod.svg',
        color: AppColors.green600,
        backgroundColor: AppColors.successBackground,
      ),
      _MetricData(
        title: 'total_expense'.tr(),
        value: Utils.formatCurrencyWithUnit(periodDetail?.totalOut),
        icon: 'assets/icons/finance_delivery.svg',
        color: AppColors.primaryDark,
        backgroundColor: AppColors.warningBackground,
      ),
      _MetricData(
        title: 'order_discount'.tr(),
        value: Utils.formatCurrencyWithUnit(periodDetail?.orderDiscount),
        icon: 'assets/icons/finance_voucher.svg',
        color: AppColors.secondary,
        backgroundColor: AppColors.surfaceVariant,
      ),
      _MetricData(
        title: 'customer_discount'.tr(),
        value: Utils.formatCurrencyWithUnit(periodDetail?.volumeDiscountAmount),
        icon: 'assets/icons/finance_voucher.svg',
        color: AppColors.secondary,
        backgroundColor: AppColors.surfaceVariant,
      ),
      _MetricData(
        title: 'net_payable'.tr(),
        value: Utils.formatCurrencyWithUnit(periodDetail?.netPayable),
        icon: 'assets/icons/finance_wallet.svg',
        color: AppColors.primary,
        backgroundColor: AppColors.warningBackground,
      ),
      _MetricData(
        title: 'order_count'.tr(),
        value: '${periodDetail?.orderCount ?? 0}',
        icon: 'assets/icons/finance_delivery.svg',
        color: AppColors.secondary,
        backgroundColor: AppColors.surfaceVariant,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: metrics.map((metric) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: _MetricCard(metric: metric),
        );
      }).toList(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: metric.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              metric.icon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(metric.color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            metric.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              metric.value,
              style: TextStyle(
                fontSize: 18,
                color: metric.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.value,
    this.trailing,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.grey200))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
          ),
          trailing ??
              Text(
                value?.isNotEmpty == true ? value! : '--',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
        ],
      ),
    );
  }
}

class _DailyBreakdownTile extends StatelessWidget {
  const _DailyBreakdownTile({required this.dailyEntity});

  final DailyBreakdownEntity dailyEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTimeUtils.formatDateFromDT(dailyEntity.date) ?? '--',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'COD',
            value: Utils.formatCurrencyWithUnit(dailyEntity.codCollected),
          ),
          _InfoRow(
            label: 'total_income'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity.totalIn),
          ),
          _InfoRow(
            label: 'total_expense'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity.totalOut),
          ),
          _InfoRow(
            label: 'balance'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity.netAmount),
          ),
          _InfoRow(
            label: 'delivery_order'.tr(),
            value: '${dailyEntity.orderCount ?? 0}',
          ),
          _InfoRow(
            label: 'returned_orders'.tr(),
            value: '${dailyEntity.returnedOrderCount ?? 0}',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
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

class _MetricData {
  const _MetricData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final String title;
  final String value;
  final String icon;
  final Color color;
  final Color backgroundColor;
}
