import 'package:oneship_shop/features/finance/enum.dart';

abstract class FinanceReconciliationEvent {
  FinanceReconciliationEvent();
}

class FinanceReconciliationSelectFilterEvent
    extends FinanceReconciliationEvent {
  final ReconciliationFilter filter;

  FinanceReconciliationSelectFilterEvent({required this.filter});
}

class FinanceReconciliationAddShopIdEvent extends FinanceReconciliationEvent {
  final String shopId;
  FinanceReconciliationAddShopIdEvent({required this.shopId});
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
  FinanceReconciliationFetchPeriodsEvent();
}

class FinanceReconciliationFetchPayoutsEvent
    extends FinanceReconciliationEvent {
  FinanceReconciliationFetchPayoutsEvent();
}

class FinanceReconciliationFetchConfigEvent extends FinanceReconciliationEvent {
  FinanceReconciliationFetchConfigEvent();
}
