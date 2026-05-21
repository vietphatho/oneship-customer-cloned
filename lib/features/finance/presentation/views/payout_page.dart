import 'package:flutter/material.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';

class PayoutPage extends StatelessWidget {
  const PayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceReconciliationBloc financeReconciliationBloc = getIt.get();
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
            //   financeReconciliationBloc.changedPeriodStatus(value!);
            // },
          ),
          Expanded(child: PrimaryEmptyData()),
        ],
      ),
    );
  }
}
