import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_state.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/payout_page.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/periods_page.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/views/reconciliation_cycle_page.dart';

class VendorFinanceReconciliationTabView extends StatelessWidget {
  VendorFinanceReconciliationTabView({super.key});

  final VendorFinanceReconciliationBloc _vendorFinanceReconciliationBloc = getIt
      .get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      VendorFinanceReconciliationBloc,
      VendorFinanceReconciliationState
    >(
      bloc: _vendorFinanceReconciliationBloc,
      buildWhen: (pre, cur) =>
          pre.reconciliationFilter != cur.reconciliationFilter,
      builder: (context, state) {
        switch (state.reconciliationFilter) {
          case ReconciliationFilter.period:
            return PeriodsPage();
          case ReconciliationFilter.payout:
            return PayoutPage();
          case ReconciliationFilter.config:
            return ReconciliationCyclePage();
        }
      },
    );
  }
}
