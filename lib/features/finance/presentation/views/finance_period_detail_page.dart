import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_card.dart';
import 'package:oneship_shop/core/base/components/primary_empty_data.dart';
import 'package:oneship_shop/core/base/components/primary_status.dart';
import 'package:oneship_shop/core/utils/date_time_utils.dart';
import 'package:oneship_shop/core/utils/utils.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/finance/domain/entities/period_detail_entity.dart';
import 'package:oneship_shop/features/finance/enum.dart';
import 'package:oneship_shop/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_shop/features/finance/presentation/widgets/finance_overview_card.dart';
import 'package:oneship_shop/features/finance/presentation/widgets/finance_text_row.dart';

class FinancePeriodDetailPage extends StatelessWidget {
  const FinancePeriodDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceReconciliationBloc financeReconciliationBloc = getIt.get();
    final periodDetail =
        financeReconciliationBloc.state.periodDetailEntity.data;
    return Scaffold(
      appBar: PrimaryAppBar(title: 'Chi tiet doi soat'),
      body: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                periodDetail?.periodCode,
                style: AppTextStyles.titleXXLarge,
              ),
              PrimaryText(
                '${DateTimeUtils.formatDateFromDT(periodDetail?.startedAt)} - ${DateTimeUtils.formatDateFromDT(periodDetail?.endedAt)}',
                style: AppTextStyles.labelMedium,
              ),
              AppSpacing.vertical(AppDimensions.xLargeSpacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "total_income".tr(),
                      value: Utils.formatCurrencyWithUnit(
                        periodDetail?.totalIn,
                      ),
                      icon: Icons.attach_money_rounded,
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "total_expense".tr(),
                      value: Utils.formatCurrencyWithUnit(
                        periodDetail?.totalOut,
                      ),
                      icon: Icons.attach_money_rounded,
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "order_discount".tr(),
                      value: Utils.formatCurrencyWithUnit(
                        periodDetail?.orderDiscount,
                      ),
                      icon: Icons.discount,
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "customer_discount".tr(),
                      value: Utils.formatCurrencyWithUnit(
                        periodDetail?.volumeDiscountAmount,
                      ),
                      icon: Icons.discount,
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "net_payable".tr(),
                      value: Utils.formatCurrencyWithUnit(
                        periodDetail?.netPayable,
                      ),
                      icon: Icons.account_balance_wallet_rounded,
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Expanded(
                    child: FinanceOverviewCard(
                      label: "order_count".tr(),
                      value: "${periodDetail?.orderCount}",
                      icon: Icons.category_rounded,
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _buildPeriodInformation(periodDetail),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              _buildPayout(periodDetail),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildDetailByDay(
                    periodDetail?.dailyBreakdown?[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return AppSpacing.vertical(AppDimensions.mediumSpacing);
                },
                itemCount: periodDetail?.dailyBreakdown?.length ?? 0,
              ),
              AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodInformation(PeriodDetailEntity? periodDetail) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'period_information'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'period_type'.tr(),
            value: "${periodDetail?.periodType}".tr(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'start_date'.tr(),
            value: "${DateTimeUtils.formatDateFromDT(periodDetail?.startedAt)}",
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'end_date'.tr(),
            value: "${DateTimeUtils.formatDateFromDT(periodDetail?.endedAt)}",
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'status'.tr(),
            widget: PrimaryStatus(
              color:
                  periodDetail?.periodStatus.getStatusColor() ??
                  AppColors.primary,
              label: "${periodDetail?.status}".tr(),
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'adjustment'.tr(),
            value: Utils.formatCurrencyWithUnit(periodDetail?.totalAdjustment),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'created_at'.tr(),
            value: "${DateTimeUtils.formatDateFromDT(periodDetail?.createdAt)}",
          ),
        ],
      ),
    );
  }

  Widget _buildPayout(PeriodDetailEntity? periodDetail) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'payment_information'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryEmptyData(),
        ],
      ),
    );
  }

  Widget _buildDetailByDay(DailyBreakdownEntity? dailyEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('detail_by_day'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'date'.tr(),
            value: '${DateTimeUtils.formatDateFromDT(dailyEntity?.date)}',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'cod'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity?.codCollected),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'total_income'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity?.totalIn),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'total_expense'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity?.totalOut),
            valueStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.expenseRed,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'balance_after'.tr(),
            value: Utils.formatCurrencyWithUnit(dailyEntity?.netAmount),
            valueStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.incomeGreen,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'successful_orders'.tr(),
            value: dailyEntity?.orderCount.toString(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'returned_orders'.tr(),
            value: dailyEntity?.returnedOrderCount.toString(),
            valueStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.expenseRed,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
        ],
      ),
    );
  }
}
