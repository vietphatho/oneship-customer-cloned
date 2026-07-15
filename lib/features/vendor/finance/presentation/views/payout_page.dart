import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';

class PayoutPage extends StatelessWidget {
  const PayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        children: [
          PrimaryText('payout'.tr(), style: AppTextStyles.titleXXLarge),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryDropdown<PayoutStatus>(
            menu: PayoutStatus.values,
            toLabel: (item) => item.name.tr(),
            initialValue: PayoutStatus.all,
            // onSelected: (value) {
            //   vendorFinanceReconciliationBloc.changedSettlementStatus(value!);
            // },
          ),
          Expanded(child: PrimaryEmptyData()),
        ],
      ),
    );
  }
}
