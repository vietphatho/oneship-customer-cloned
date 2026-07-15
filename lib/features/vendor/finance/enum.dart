import 'dart:ui';

import 'package:oneship_customer/core/themes/app_colors.dart';

enum VendorFinanceRequestSource { page, filterDialog }

enum VendorFinanceFilter { oneDay, sevenDay, thirtyDay, selectDate }

extension VendorFinanceFilterX on VendorFinanceFilter {
  static const _mapName = {
    VendorFinanceFilter.oneDay: 'one_day',
    VendorFinanceFilter.sevenDay: 'seven_day',
    VendorFinanceFilter.thirtyDay: 'thirty_day',
    VendorFinanceFilter.selectDate: 'select_date',
  };

  String get name => _mapName[this]!;

  DateTime? getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case VendorFinanceFilter.oneDay:
        return DateTime(now.year, now.month, now.day - 1);
      case VendorFinanceFilter.sevenDay:
        return DateTime(now.year, now.month, now.day - 7);
      case VendorFinanceFilter.thirtyDay:
        return DateTime(now.year, now.month, now.day - 30);
      case VendorFinanceFilter.selectDate:
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

enum SettlementStatus { all, open, locked, approved, cancelled }

extension SettlementStatusX on SettlementStatus {
  static const _mapName = {
    SettlementStatus.all: 'all',
    SettlementStatus.open: 'open',
    SettlementStatus.locked: 'locked',
    SettlementStatus.approved: 'approved',
    SettlementStatus.cancelled: 'cancelled',
  };

  String get name => _mapName[this]!;

  Color? getStatusColor() {
    switch (this) {
      case SettlementStatus.open:
        return AppColors.open;
      case SettlementStatus.locked:
        return AppColors.locked;
      case SettlementStatus.approved:
        return AppColors.approved;
      case SettlementStatus.cancelled:
        return AppColors.cancelled;
      default:
        return AppColors.primary;
    }
  }
}

enum SettlementPeriodType { daily, weekly, biweekly, monthly }

extension SettlementPeriodTypeX on SettlementPeriodType {
  static const _mapName = {
    SettlementPeriodType.daily: 'daily',
    SettlementPeriodType.weekly: 'weekly',
    SettlementPeriodType.biweekly: 'biweekly',
    SettlementPeriodType.monthly: 'monthly',
  };

  String get name => _mapName[this]!;
}

enum PayoutStatus { all, pending, processing, completed, failed, cancelled }

extension PayoutStatusX on PayoutStatus {
  static const _mapName = {
    PayoutStatus.all: 'all',
    PayoutStatus.pending: 'pending',
    PayoutStatus.processing: 'processing',
    PayoutStatus.completed: 'completed',
    PayoutStatus.failed: 'failed',
    PayoutStatus.cancelled: 'cancelled',
  };

  String get name => _mapName[this]!;
}

enum VendorFinanceSubFeature { overview, reconciliation, settlementCycle }
