import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_text_row.dart';

class FinanceDetailByDay extends StatelessWidget {
  const FinanceDetailByDay({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceOverviewBloc financeOverviewBloc = getIt.get();
    final List<DailyBreakdownEntity> listDailyBreakdown =
        financeOverviewBloc.state.shopFinancialData.data?.dailyBreakdown ?? [];
    return Scaffold(
      appBar: PrimaryAppBar(title: 'detail_by_day'.tr()),
      body: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child:
            listDailyBreakdown.isEmpty
                ? PrimaryEmptyData()
                : ListView.separated(
                  itemBuilder: (context, index) {
                    final DailyBreakdownEntity dailyBreakdownEntity =
                        listDailyBreakdown[index];
                    return _FinanceDetailByDayItem(
                      date: DateFormat(
                        Constants.requestDateFormat,
                      ).parse(dailyBreakdownEntity.date.toString()),
                      codCollected: dailyBreakdownEntity.codCollected ?? 0,
                      deliveryFee: dailyBreakdownEntity.deliveryFee ?? 0,
                      surchargeFee: dailyBreakdownEntity.surchargeFee ?? 0,
                      returnedFee: dailyBreakdownEntity.totalReturnedFee,
                      netAmount: dailyBreakdownEntity.netAmount ?? 0,
                      orderCount: dailyBreakdownEntity.orderCount ?? 0,
                      returnedOrderCount:
                          dailyBreakdownEntity.returnedOrderCount ?? 0,
                    );
                  },
                  separatorBuilder:
                      (context, index) =>
                          AppSpacing.vertical(AppDimensions.mediumSpacing),
                  itemCount: listDailyBreakdown.length,
                ),
      ),
    );
  }
}

class _FinanceDetailByDayItem extends StatelessWidget {
  const _FinanceDetailByDayItem({
    required this.date,
    required this.codCollected,
    required this.deliveryFee,
    required this.surchargeFee,
    required this.returnedFee,
    required this.netAmount,
    required this.orderCount,
    required this.returnedOrderCount,
  });

  final DateTime? date;
  final int codCollected;
  final int deliveryFee;
  final int surchargeFee;
  final int returnedFee;
  final int netAmount;
  final int orderCount;
  final int returnedOrderCount;

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('detail_by_day'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'date'.tr(),
            value: '${DateTimeUtils.formatDateFromDT(date)}',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'cod'.tr(),
            value: Utils.formatCurrencyWithUnit(codCollected),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'shipping_fee'.tr(),
            value: Utils.formatCurrencyWithUnit(deliveryFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'surcharge'.tr(),
            value: Utils.formatCurrencyWithUnit(surchargeFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'return_order_fee'.tr(),
            value: Utils.formatCurrencyWithUnit(returnedFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'balance_after'.tr(),
            value: Utils.formatCurrencyWithUnit(netAmount),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'successful_orders'.tr(),
            value: orderCount.toString(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'returned_orders'.tr(),
            value: returnedOrderCount.toString(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
        ],
      ),
    );
  }
}
