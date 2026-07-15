import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/settlement_config_entity.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_bloc.dart';
import 'package:oneship_customer/features/vendor/finance/presentation/bloc/finance_reconciliation_state.dart';

const _cardRadius = 16.0;
const _cardPadding = EdgeInsets.all(16);
const _sectionSpacing = SizedBox(height: 16);

class ReconciliationCyclePage extends StatelessWidget {
  ReconciliationCyclePage({super.key});

  final VendorFinanceReconciliationBloc _bloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      VendorFinanceReconciliationBloc,
      VendorFinanceReconciliationState
    >(
      bloc: _bloc,
      buildWhen: (previous, current) =>
          previous.settlementConfigResource != current.settlementConfigResource,
      builder: (context, state) {
        if (state.settlementConfigResource.state == Result.error) {
          return PrimaryEmptyData(onRetry: _bloc.fetchSettlementConfig);
        }

        final config = state.settlementConfigResource.data;
        return ColoredBox(
          color: AppColors.financePageBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CycleCard(config: config),
                _sectionSpacing,
                _BankCard(config: config),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({required this.config});

  final SettlementConfigEntity? config;

  @override
  Widget build(BuildContext context) {
    return _ConfigCard(
      title: 'reconciliation_cycle'.tr(),
      icon: 'assets/icons/finance_calendar.svg',
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.15,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _ConfigValue(
            label: 'reconciliation_cycle'.tr(),
            value: _cycleText(config?.settlementCycle),
          ),
          _ConfigValue(
            label: 'reconciliation_date'.tr(),
            value: _settlementDay(config),
          ),
          _ConfigValue(
            label: 'auto_create_period'.tr(),
            value: config?.autoCreatePeriod == true
                ? 'true'.tr()
                : 'false'.tr(),
            success: config?.autoCreatePeriod == true,
          ),
          _ConfigValue(
            label: 'auto_lock'.tr(),
            value: config?.autoLockDays == null
                ? '--'
                : 'days_count'.tr(
                    namedArgs: {'count': '${config!.autoLockDays}'},
                  ),
          ),
        ],
      ),
    );
  }

  static String _cycleText(String? cycle) {
    return switch (cycle?.toLowerCase()) {
      'daily' => 'daily'.tr(),
      'weekly' => 'weekly'.tr(),
      'monthly' => 'monthly'.tr(),
      null || '' => '--',
      _ => cycle!,
    };
  }

  static String _settlementDay(SettlementConfigEntity? config) {
    if (config?.dayOfMonth != null) {
      return 'day_of_month_format'.tr(
        namedArgs: {'day': '${config!.dayOfMonth}'},
      );
    }
    if (config?.dayOfWeek != null) {
      return 'day_of_week_format'.tr(
        namedArgs: {'day': '${config!.dayOfWeek}'},
      );
    }
    return '--';
  }
}

class _BankCard extends StatelessWidget {
  const _BankCard({required this.config});

  final SettlementConfigEntity? config;

  @override
  Widget build(BuildContext context) {
    final hasBankInfo = config?.hasBankInfo == true;
    return _ConfigCard(
      title: 'bank_information'.tr(),
      icon: 'assets/icons/finance_wallet.svg',
      child: hasBankInfo
          ? Column(
              children: [
                _BankRow(label: 'bank_name'.tr(), value: config?.bankName),
                _BankRow(
                  label: 'bank_acc_number'.tr(),
                  value: config?.accountNumber?.toString(),
                ),
                _BankRow(
                  label: 'bank_acc_owner_name'.tr(),
                  value: config?.accountHolder,
                ),
                _BankRow(label: 'branch'.tr(), value: config?.branch),
              ],
            )
          : const _BankEmptyState(),
    );
  }
}

class _BankEmptyState extends StatelessWidget {
  const _BankEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card_outlined,
              size: 42,
              color: AppColors.grey600,
            ),
            const SizedBox(height: 12),
            Text(
              'no_bank_info'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'please_update_bank_info'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final String icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ConfigValue extends StatelessWidget {
  const _ConfigValue({
    required this.label,
    required this.value,
    this.success = false,
  });

  final String label;
  final String value;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            if (success) ...[
              const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: AppColors.green600,
              ),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.grey600),
            ),
          ),
          Text(
            value?.isNotEmpty == true ? value! : '--',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
