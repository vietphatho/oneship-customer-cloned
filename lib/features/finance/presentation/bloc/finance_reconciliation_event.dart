import 'package:oneship_customer/features/finance/enum.dart';

abstract class FinanceReconciliationEvent {
  FinanceReconciliationEvent();
}

class FinanceReconciliationSelectFilterEvent
    extends FinanceReconciliationEvent {
  final ReconciliationFilter filter;

  FinanceReconciliationSelectFilterEvent({required this.filter});
}

class FinanceReconciliationChangePeriodStatusEvent
    extends FinanceReconciliationEvent {
  final PeriodStatus status;

  FinanceReconciliationChangePeriodStatusEvent({required this.status});
}

class FinanceReconciliationFetchPeriodDetailEvent
    extends FinanceReconciliationEvent {
  final String shopId;
  final String id;

  FinanceReconciliationFetchPeriodDetailEvent({
    required this.shopId,
    required this.id,
  });
}

class FinanceReconciliationFetchPeriodsEvent
    extends FinanceReconciliationEvent {
  final String shopId;
  FinanceReconciliationFetchPeriodsEvent({required this.shopId});
}

class FinanceReconciliationFetchConfigEvent
    extends FinanceReconciliationEvent {
  final String shopId;
  FinanceReconciliationFetchConfigEvent({required this.shopId});
}
