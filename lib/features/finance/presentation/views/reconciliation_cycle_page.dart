import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/finance/presentation/bloc/finance_reconciliation_state.dart';
import 'package:oneship_customer/features/finance/presentation/widgets/finance_text_row.dart';

class ReconciliationCyclePage extends StatelessWidget {
  const ReconciliationCyclePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceReconciliationBloc financeReconciliationBloc = getIt.get();
    return Padding(
      padding: AppDimensions.mediumPaddingAll,
      child: Column(
        children: [
          PrimaryText(
            'reconciliation_cycle'.tr(),
            style: AppTextStyles.titleXXLarge,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          PrimaryText(
            "${"period".tr()} & ${"payout".tr()}",
            style: AppTextStyles.bodyLarge,
          ),
          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
          BlocBuilder<FinanceReconciliationBloc, FinanceReconciliationState>(
            bloc: financeReconciliationBloc,
            buildWhen:
                (pre, cur) =>
                    pre.settlementConfigResource !=
                    cur.settlementConfigResource,
            builder: (context, state) {
              if (state.settlementConfigResource.state == Result.error) {
                return PrimaryEmptyData(
                  onRetry: () {
                    financeReconciliationBloc.fetchSettlementConfig();
                  },
                );
              }

              return Column(
                children: [
                  _buildPeriodInformation(state.settlementConfigResource.data),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  _buildBankInformation(state.settlementConfigResource.data),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodInformation(SettlementConfigEntity? configEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            'reconciliation_cycle'.tr(),
            style: AppTextStyles.titleLarge,
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'reconciliation_cycle'.tr(),
            value: "${configEntity?.settlementCycle}".tr(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'reconciliation_date'.tr(),
            value: "${"date".tr()} ${configEntity?.dayOfMonth}",
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'auto_create_period'.tr(),
            value: "${configEntity?.autoCreatePeriod}".tr(),
          ),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          FinanceTextRow(
            label: 'auto_lock'.tr(),
            value: "${configEntity?.autoLockDays.toString()} ${"date".tr()}",
          ),
        ],
      ),
    );
  }

  Widget _buildBankInformation(SettlementConfigEntity? configEntity) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText('bank_information'.tr(), style: AppTextStyles.titleLarge),
          AppSpacing.vertical(AppDimensions.xSmallSpacing),
          PrimaryEmptyData(),
        ],
      ),
    );
  }
}
