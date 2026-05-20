import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dropdown.dart';
import 'package:oneship_customer/core/base/components/primary_text.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_period_card.dart';

class FinanceReconciliationTabView extends StatelessWidget {
  FinanceReconciliationTabView({super.key});

  final FinanceReconciliationBloc _financeReconciliationBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    PeriodEntity();
    return Padding(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        children: [
          PrimaryText('Ky doi soat'),
          PrimaryDropdown<Status>(
            menu: Status.values,
            toLabel: (item) => item.name.tr(),
            initialValue: Status.all,
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          BlocBuilder<FinanceReconciliationBloc, FinanceReconciliationState>(
            bloc: _financeReconciliationBloc,
            buildWhen:
                (pre, cur) =>
                    pre.settlementPeriods.state != cur.settlementPeriods.state,

            builder: (context, state) {
              final periods = state.settlementPeriods.data?.items ?? [];
              return Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return FinancePeriodCard(periodEntity: periods[index]);
                  },
                  separatorBuilder: (context, index) {
                    return AppSpacing.vertical(AppDimensions.mediumSpacing);
                  },
                  itemCount: periods.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
