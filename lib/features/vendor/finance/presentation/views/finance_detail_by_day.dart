import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_overview_bloc.dart';

class VendorFinanceDetailByDay extends StatelessWidget {
  const VendorFinanceDetailByDay({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorFinanceOverviewBloc = getIt.get<VendorFinanceOverviewBloc>();
    final dailyBreakdown =
        vendorFinanceOverviewBloc
            .state
            .vendorFinancialData
            .data
            ?.dailyBreakdown ??
        [];

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'detail_by_day'.tr(),
        titleColor: AppColors.blue950,
      ),
      backgroundColor: AppColors.financePageBackground,
      body: dailyBreakdown.isEmpty
          ? const PrimaryEmptyData()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: dailyBreakdown.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _VendorFinanceDetailByDayItem(
                  dailyBreakdown: dailyBreakdown[index],
                );
              },
            ),
    );
  }
}

class _VendorFinanceDetailByDayItem extends StatelessWidget {
  const _VendorFinanceDetailByDayItem({required this.dailyBreakdown});

  final DailyBreakdownEntity dailyBreakdown;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(dailyBreakdown.date ?? '');
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _VendorFinanceDetailIcon(
                asset: 'assets/icons/finance_calendar.svg',
                color: AppColors.primary,
                backgroundColor: AppColors.warningBackground,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'detail_by_day'.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateTimeUtils.formatDateFromDT(date) ?? '--',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PrimaryAmountTile(
                  title: 'cod_collection'.tr(),
                  value: Utils.formatCurrencyWithUnit(
                    dailyBreakdown.codCollected,
                  ),
                  color: AppColors.green600,
                  backgroundColor: AppColors.successBackground,
                  icon: 'assets/icons/finance_cod.svg',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryAmountTile(
                  title: 'delivery_fee_title'.tr(),
                  value: Utils.formatCurrencyWithUnit(dailyBreakdown.totalOut),
                  color: AppColors.primaryDark,
                  backgroundColor: AppColors.warningBackground,
                  icon: 'assets/icons/finance_delivery.svg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoGrid(
            items: [
              _InfoItem(
                label: 'surcharge'.tr(),
                value: Utils.formatCurrencyWithUnit(
                  dailyBreakdown.surchargeFee,
                ),
                icon: 'assets/icons/finance_wallet.svg',
                color: AppColors.primary,
              ),
              _InfoItem(
                label: 'return_shipping_fee'.tr(),
                value: Utils.formatCurrencyWithUnit(
                  dailyBreakdown.totalReturnedFee,
                ),
                icon: 'assets/icons/finance_return.svg',
                color: AppColors.error,
              ),
              _InfoItem(
                label: 'balance'.tr(),
                value: Utils.formatCurrencyWithUnit(dailyBreakdown.netAmount),
                icon: 'assets/icons/finance_wallet.svg',
                color: AppColors.green600,
              ),
              _InfoItem(
                label: 'delivery_order'.tr(),
                value: '${dailyBreakdown.orderCount ?? 0}',
                icon: 'assets/icons/finance_delivery.svg',
                color: AppColors.primary,
              ),
              _InfoItem(
                label: 'returned_orders'.tr(),
                value: '${dailyBreakdown.returnedOrderCount ?? 0}',
                icon: 'assets/icons/finance_return.svg',
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryAmountTile extends StatelessWidget {
  const _PrimaryAmountTile({
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VendorFinanceDetailIcon(
            asset: icon,
            color: color,
            backgroundColor: Colors.white.withAlpha(180),
            size: 18,
            containerSize: 32,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.grey600),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 52) / 2,
          child: _InfoTile(item: item),
        );
      }).toList(),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.financePageBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            item.icon,
            width: 17,
            height: 17,
            colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _VendorFinanceDetailIcon extends StatelessWidget {
  const _VendorFinanceDetailIcon({
    required this.asset,
    required this.color,
    required this.backgroundColor,
    this.size = 20,
    this.containerSize = 40,
  });

  final String asset;
  final Color color;
  final Color backgroundColor;
  final double size;
  final double containerSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: SvgPicture.asset(
        asset,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

class _InfoItem {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final Color color;
}
