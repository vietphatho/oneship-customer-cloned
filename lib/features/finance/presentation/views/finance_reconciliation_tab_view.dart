import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';
import 'package:oneship_customer/features/finance/presentation/views/periods_page.dart';
import 'package:oneship_customer/features/finance/presentation/views/reconciliation_cycle_page.dart';

class FinanceReconciliationTabView extends StatelessWidget {
  FinanceReconciliationTabView({super.key});

  final FinanceReconciliationBloc _financeReconciliationBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceReconciliationBloc, FinanceReconciliationState>(
      bloc: _financeReconciliationBloc,
      buildWhen:
          (pre, cur) => pre.reconciliationFilter != cur.reconciliationFilter,
      builder: (context, state) {
        switch (state.reconciliationFilter) {
          case ReconciliationFilter.period:
            return PeriodsPage();
          case ReconciliationFilter.payout:
            return _PayoutPage();
          case ReconciliationFilter.config:
            return ReconciliationCyclePage();
        }
      },
    );
  }
}

class _PayoutPage extends StatelessWidget {
  const _PayoutPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        children: [
          PrimaryText('payout'.tr(), style: AppTextStyles.titleXXLarge),
          Expanded(child: PrimaryEmptyData()),
        ],
      ),
    );
  }
}