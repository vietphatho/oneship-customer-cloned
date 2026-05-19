import 'package:oneship_customer/features/finance/enum.dart';

abstract class FinanceReconciliationEvent {
  FinanceReconciliationEvent();
}

class FinanceReconciliationSelectFilterEvent extends FinanceReconciliationEvent {
  final ReconciliationFilter filter;

  FinanceReconciliationSelectFilterEvent({
    required this.filter,
  });
}

class FinanceReconciliationFetchPeriodsEvent extends FinanceReconciliationEvent {
  final String shopId;
  FinanceReconciliationFetchPeriodsEvent({required this.shopId});
}
