import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_period_card.dart';

class PeriodsPage extends StatelessWidget {
  const PeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceReconciliationBloc financeReconciliationBloc = getIt.get();
    return Padding(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        children: [
          PrimaryText('period'.tr(), style: AppTextStyles.titleXXLarge),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryDropdown<PeriodStatus>(
            menu: PeriodStatus.values,
            toLabel: (item) => item.name.tr(),
            initialValue: financeReconciliationBloc.state.periodStatus,
            onSelected: (value) {
              financeReconciliationBloc.changedPeriodStatus(value!);
            },
          ),
          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
          MultiBlocListener(
            listeners: [
              BlocListener<
                FinanceReconciliationBloc,
                FinanceReconciliationState
              >(
                bloc: financeReconciliationBloc,
                listenWhen:
                    (pre, cur) =>
                        pre.settlementPeriodsResource.state !=
                        cur.settlementPeriodsResource.state,
                listener: _handleChangePeriodStatus,
              ),
              BlocListener<
                FinanceReconciliationBloc,
                FinanceReconciliationState
              >(
                bloc: financeReconciliationBloc,
                listenWhen:
                    (pre, cur) =>
                        pre.periodDetailEntity.state !=
                        cur.periodDetailEntity.state,
                listener: _handleFetchPeriodDetail,
              ),
            ],
            child: BlocBuilder<
              FinanceReconciliationBloc,
              FinanceReconciliationState
            >(
              bloc: financeReconciliationBloc,

              buildWhen: (pre, cur) => pre.periodsData != cur.periodsData,
              builder: (context, state) {
                if (state.settlementPeriodsResource.state == Result.error) {
                  return Expanded(
                    child: PrimaryEmptyData(
                      onRetry:
                          () =>
                              financeReconciliationBloc
                                  .fetchSettlementPeriods(),
                    ),
                  );
                }

                final periods = state.periodsData;

                if (periods.isEmpty) return Expanded(child: PrimaryEmptyData());

                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return FinancePeriodCard(
                        periodEntity: periods[index],
                        onTap: () {
                          financeReconciliationBloc.fetchPeriodDetail(
                            shopId: periods[index].shopId ?? "",
                            id: periods[index].id ?? "",
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return AppSpacing.vertical(AppDimensions.mediumSpacing);
                    },
                    itemCount: periods.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleChangePeriodStatus(
    BuildContext context,
    FinanceReconciliationState state,
  ) {
    switch (state.settlementPeriodsResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
        break;
    }
  }

  void _handleFetchPeriodDetail(
    BuildContext context,
    FinanceReconciliationState state,
  ) {
    switch (state.periodDetailEntity.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.financePeriodDetailPage);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
        break;
    }
  }
}
