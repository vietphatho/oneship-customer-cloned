import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_date_time_picker.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_tab_bar.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_overview_card.dart';

class FinanceOverviewTabView extends StatefulWidget {
  const FinanceOverviewTabView({super.key});

  @override
  State<FinanceOverviewTabView> createState() => _FinanceOverviewTabViewState();
}

class _FinanceOverviewTabViewState extends State<FinanceOverviewTabView>
    with SingleTickerProviderStateMixin {
  late DateTime fromDate;
  late DateTime toDate;

  late List<String> _tabList;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now();
    _tabList = const ['24 gio', '7 ngay', '30 ngay'];
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: AppDimensions.getSize(context).width,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.mediumSpacing),
        child: Column(
          children: [
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            PrimaryText(
              '22/04/2026 - 23/04/2026',
              style: AppTextStyles.titleXLarge,
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DefaultTabController(
                    length: _tabList.length,
                    child: PrimaryTabBar(
                      height: AppDimensions.mediumHeightButton,
                      items: _tabList,
                      controller: _tabController,
                      borderRadius: AppDimensions.mediumBorderRadius,
                      onTap: (index) {},
                    ),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                Expanded(
                  flex: 1,
                  child: PrimaryButton.iconFilled(
                    icon: Icon(
                      Icons.date_range,
                      color: AppColors.backgroundColor,
                    ),
                    label: 'select_date'.tr(),
                    onPressed: () {
                      PrimaryDialog.showCustomDialog(
                        context,
                        child: _selectedDateDialog(),
                        actionButtons: PrimaryButton.filled(
                          label: 'done'.tr(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            Row(
              children: [
                Expanded(
                  child: FinanceOverviewCard(
                    label: "remain_balance".tr(),
                    value: "787899",
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "cod".tr(),
                    value: "787899",
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
                    value: "787899",
                    icon: Icons.attach_money_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "discount".tr(),
                    value: "787899",
                    icon: Icons.discount_rounded,
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            Row(
              children: [
                Expanded(
                  child: FinanceOverviewCard(
                    label: "total_complete_orders".tr(),
                    value: "787899",
                    icon: Icons.category_rounded,
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: FinanceOverviewCard(
                    label: "total_returned_orders".tr(),
                    value: "787899",
                    icon: Icons.category_rounded,
                  ),
                ),
              ],
            ),
            // AppSpacing.vertical(AppDimensions.smallSpacing),
            // _buildFinanceSummary(),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildFeeOrderSuccess(),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildFeeOrderReturned(),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildDiscountsAndCashback(),
            AppSpacing.vertical(AppDimensions.mediumSpacing),
            _buildDetailByDay(),
            // AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _selectedDateDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText('from_date'.tr(), style: AppTextStyles.titleLarge),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryDateTimePicker(
          onChanged: (value) {
            setState(() {
              fromDate = value;
            });
          },
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryText('to_date'.tr(), style: AppTextStyles.titleLarge),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryDateTimePicker(
          onChanged: (value) {
            setState(() {
              toDate = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFinanceSummary() {
    return Column(
      children: [
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'balance_after'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: Utils.formatCurrencyWithUnit(12222100000),
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'cod'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '-100.000',
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'total'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '-100.000',
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'discount_1'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '0',
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'successful_orders'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '1',
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
        AppSpacing.vertical(AppDimensions.mediumSpacing),
        PrimaryCard(
          child: _buildFinanceRowItem(
            label: 'returned_orders'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '1',
            valueStyle: AppTextStyles.titleXLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeOrderSuccess() {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'successful_order_fee'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'shipping_fee'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'shipping_fee_VAT'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'surcharge'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'surcharge_vat'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'total'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '-100.000',
            valueStyle: AppTextStyles.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeOrderReturned() {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('return_order_fee'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'forward_shipping_fee'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'forward_shipping_vat'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'return_shipping_fee'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'return_shipping_vat'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'surcharge'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'surcharge_vat'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'total'.tr(),
            labelStyle: AppTextStyles.titleLarge,
            value: '-100.000',
            valueStyle: AppTextStyles.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountsAndCashback() {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('discount_refund'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'discount_1'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'refund'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'adjustment'.tr(), value: '-100.000'),
        ],
      ),
    );
  }

  Widget _buildDetailByDay() {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('detail_by_day'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'date'.tr(), value: '23/04/2026'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'cod'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'shipping_fee'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'surcharge'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'return_order_fee'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(label: 'balance_after'.tr(), value: '-100.000'),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'successful_orders'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          _buildFinanceRowItem(
            label: 'returned_orders'.tr(),
            value: '-100.000',
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
        ],
      ),
    );
  }

  Widget _buildFinanceRowItem({
    required String label,
    TextStyle? labelStyle,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(label, style: labelStyle ?? AppTextStyles.bodyMedium),
        PrimaryText(value, style: valueStyle ?? AppTextStyles.titleMedium),
      ],
    );
  }
}
