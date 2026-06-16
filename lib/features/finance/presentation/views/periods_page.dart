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
    final bloc = getIt.get<FinanceReconciliationBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<FinanceReconciliationBloc, FinanceReconciliationState>(
          bloc: bloc,
          listenWhen:
              (previous, current) =>
                  previous.settlementPeriodsResource.state !=
                  current.settlementPeriodsResource.state,
          listener: _handleChangePeriodStatus,
        ),
        BlocListener<FinanceReconciliationBloc, FinanceReconciliationState>(
          bloc: bloc,
          listenWhen:
              (previous, current) =>
                  previous.periodDetailEntity.state !=
                  current.periodDetailEntity.state,
          listener: _handleFetchPeriodDetail,
        ),
      ],
      child: BlocBuilder<FinanceReconciliationBloc, FinanceReconciliationState>(
        bloc: bloc,
        buildWhen:
            (previous, current) =>
                previous.periodsData != current.periodsData ||
                previous.periodStatus != current.periodStatus,
        builder: (context, state) {
          if (state.settlementPeriodsResource.state == Result.error) {
            return PrimaryEmptyData(onRetry: bloc.fetchSettlementPeriods);
          }

          return ColoredBox(
            color: AppColors.financePageBackground,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'reconciliation_overview'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      PopupMenuButton<PeriodStatus>(
                        initialValue: state.periodStatus,
                        onSelected: bloc.changedPeriodStatus,
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder:
                            (context) =>
                                PeriodStatus.values
                                    .map(
                                      (status) => PopupMenuItem(
                                        value: status,
                                        child: Text(_statusFilterText(status)),
                                      ),
                                    )
                                    .toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _statusFilterText(state.periodStatus),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 17,
                                color: AppColors.grey500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      state.periodsData.isEmpty
                          ? const PrimaryEmptyData()
                          : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 112),
                            itemCount: state.periodsData.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final period = state.periodsData[index];
                              return FinancePeriodCard(
                                periodEntity: period,
                                onTap: () {
                                  bloc.fetchPeriodDetail(
                                    shopId: period.shopId ?? '',
                                    id: period.id ?? '',
                                  );
                                },
                              );
                            },
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _statusFilterText(PeriodStatus status) {
    return switch (status) {
      PeriodStatus.all => 'status_all'.tr(),
      PeriodStatus.open => 'status_open'.tr(),
      PeriodStatus.locked => 'status_locked'.tr(),
      PeriodStatus.approved => 'status_approved'.tr(),
      PeriodStatus.cancelled => 'status_cancelled'.tr(),
    };
  }

  void _handleChangePeriodStatus(
    BuildContext context,
    FinanceReconciliationState state,
  ) {
    switch (state.settlementPeriodsResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
    }
  }

  void _handleFetchPeriodDetail(
    BuildContext context,
    FinanceReconciliationState state,
  ) {
    switch (state.periodDetailEntity.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.financePeriodDetailPage);
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
    }
  }
}
