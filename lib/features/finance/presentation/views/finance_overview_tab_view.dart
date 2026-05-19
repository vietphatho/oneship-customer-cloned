import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_overview_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_overview_card.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_text_row.dart';

class FinanceOverviewTabView extends StatefulWidget {
  const FinanceOverviewTabView({super.key});

  @override
  State<FinanceOverviewTabView> createState() => _FinanceOverviewTabViewState();
}

class _FinanceOverviewTabViewState extends State<FinanceOverviewTabView>
    with SingleTickerProviderStateMixin {
  final FinanceOverviewBloc _financeOverviewBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    final FinanceEntity financeEntity =
        _financeOverviewBloc.state.shopFinancialData.data ?? FinanceEntity();
    return SingleChildScrollView(
      child: Container(
        width: AppDimensions.getSize(context).width,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.mediumSpacing),
        child: Column(
          children: [
            AppSpacing.vertical(AppDimensions.xxLargeSpacing),
            PrimaryText(
              'financial_overview'.tr(),
              style: AppTextStyles.titleXLarge,
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            PrimaryText(
              '${DateTimeUtils.formatDateFromDT(_financeOverviewBloc.state.startDate)} - ${DateTimeUtils.formatDateFromDT(_financeOverviewBloc.state.endDate)}',
              style: AppTextStyles.labelMedium,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            Row(
              children: [
                Expanded(
                  child: FinanceOverviewCard(
                    label: "balance_after".tr(),
                    value: Utils.formatCurrencyWithUnit(
                      financeEntity.netAmount,
                    ),
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "cod".tr(),
                    value: Utils.formatCurrencyWithUnit(
                      financeEntity.codCollected,
                    ),
                    icon: Icons.attach_money_rounded,
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            Row(
              children: [
                Expanded(
                  child: FinanceOverviewCard(
                    label: "total_expense".tr(),
                    value: Utils.formatCurrencyWithUnit(financeEntity.totalOut),
                    icon: Icons.attach_money_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "discount_1".tr(),
                    value: Utils.formatCurrencyWithUnit(
                      financeEntity.discountAmount,
                    ),
                    icon: Icons.discount_rounded,
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FinanceOverviewCard(
                    label: "total_complete_orders".tr(),
                    value: financeEntity.orderCount.toString(),
                    icon: Icons.category_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "total_returned_orders".tr(),
                    value: financeEntity.returnedOrderCount.toString(),
                    icon: Icons.category_rounded,
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildFeeOrderSuccess(financeEntity),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildFeeOrderReturned(financeEntity),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildDiscountsAndCashback(financeEntity),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryButton.outlined(
              label: 'detail_by_day'.tr(),
              onPressed: () => context.push(RouteName.financeDetailByDayPage),
            ),
            AppSpacing.vertical(AppDimensions.safeBottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeOrderSuccess(FinanceEntity financeEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'successful_order_fee'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'shipping_fee'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.deliveryFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'shipping_fee_VAT'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.deliveryFeeVat),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'surcharge'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.surchargeFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'surcharge_vat'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.surchargeVat),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'total'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: Utils.formatCurrencyWithUnit(financeEntity.totalOut),
            valueStyle: AppTextStyles.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeOrderReturned(FinanceEntity financeEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('return_order_fee'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'forward_shipping_fee'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.returnForwardFee),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'forward_shipping_vat'.tr(),
            value: Utils.formatCurrencyWithUnit(
              financeEntity.returnForwardFeeVat,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'return_shipping_fee'.tr(),
            value: Utils.formatCurrencyWithUnit(
              financeEntity.returnDeliveryFee,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'return_shipping_vat'.tr(),
            value: Utils.formatCurrencyWithUnit(
              financeEntity.returnDeliveryFeeVat,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'surcharge'.tr(),
            value: Utils.formatCurrencyWithUnit(
              financeEntity.returnSurchargeFee,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'surcharge_vat'.tr(),
            value: Utils.formatCurrencyWithUnit(
              financeEntity.returnSurchargeVat,
            ),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'total'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: Utils.formatCurrencyWithUnit(financeEntity.totalReturnedFee),
            valueStyle: AppTextStyles.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountsAndCashback(FinanceEntity financeEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('discount_refund'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'discount_1'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.discountAmount),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'refund'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.rebateAmount),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'adjustment'.tr(),
            value: Utils.formatCurrencyWithUnit(financeEntity.adjustmentAmount),
          ),
        ],
      ),
    );
  }
}
