import 'dart:ui';

import 'package:oneship_customer/core/themes/app_colors.dart';

enum FinanceRequestSource { page, filterDialog }

enum FinanceFilter { oneDay, sevenDay, thirtyDay, selectDate }

extension FinanceFilterX on FinanceFilter {
  static const _mapName = {
    FinanceFilter.oneDay: 'one_day',
    FinanceFilter.sevenDay: 'seven_day',
    FinanceFilter.thirtyDay: 'thirty_day',
    FinanceFilter.selectDate: 'select_date',
  };

  String get name => _mapName[this]!;

  DateTime? getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case FinanceFilter.oneDay:
        return DateTime(now.year, now.month, now.day - 1);
      case FinanceFilter.sevenDay:
        return DateTime(now.year, now.month, now.day - 7);
      case FinanceFilter.thirtyDay:
        return DateTime(now.year, now.month, now.day - 30);
      case FinanceFilter.selectDate:
        return null;
    }
  }
}

enum ReconciliationFilter { period, payout, config }

extension ReconciliationFilterX on ReconciliationFilter {
  static const _mapName = {
    ReconciliationFilter.period: 'period',
    ReconciliationFilter.payout: 'payout',
    ReconciliationFilter.config: 'reconciliation_cycle',
  };

  String get name => _mapName[this]!;
}

enum PeriodStatus { all, open, locked, approved, cancelled }

extension PeriodStatusX on PeriodStatus {
  static const _mapName = {
    PeriodStatus.all: 'all',
    PeriodStatus.open: 'open',
    PeriodStatus.locked: 'locked',
    PeriodStatus.approved: 'approved',
    PeriodStatus.cancelled: 'cancelled',
  };

  String get name => _mapName[this]!;

  Color? getStatusColor() {
    switch (this) {
      case PeriodStatus.open:
        return AppColors.open;
      case PeriodStatus.locked:
        return AppColors.locked;
      case PeriodStatus.approved:
        return AppColors.approved;
      case PeriodStatus.cancelled:
        return AppColors.cancelled;
      default:
        return AppColors.primary;
    }
  }
}
