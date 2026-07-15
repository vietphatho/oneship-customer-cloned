import 'package:oneship_customer/features/vendor/finance/enum.dart';

abstract class VendorFinanceReconciliationEvent {
  VendorFinanceReconciliationEvent();
}

class VendorFinanceReconciliationSelectFilterEvent
    extends VendorFinanceReconciliationEvent {
  final ReconciliationFilter filter;

  VendorFinanceReconciliationSelectFilterEvent({required this.filter});
}

class VendorFinanceReconciliationAddUserIdEvent
    extends VendorFinanceReconciliationEvent {
  final String userId;
  VendorFinanceReconciliationAddUserIdEvent({required this.userId});
}

class VendorFinanceReconciliationChangeSettlementStatusEvent
    extends VendorFinanceReconciliationEvent {
  final SettlementStatus status;

  VendorFinanceReconciliationChangeSettlementStatusEvent({
    required this.status,
  });
}

class VendorFinanceReconciliationFetchPeriodDetailEvent
    extends VendorFinanceReconciliationEvent {
  final String userId;
  final String id;

  VendorFinanceReconciliationFetchPeriodDetailEvent({
    required this.userId,
    required this.id,
  });
}

class VendorFinanceReconciliationFetchPeriodsEvent
    extends VendorFinanceReconciliationEvent {
  VendorFinanceReconciliationFetchPeriodsEvent();
}

class VendorFinanceReconciliationFetchPayoutsEvent
    extends VendorFinanceReconciliationEvent {
  VendorFinanceReconciliationFetchPayoutsEvent();
}

class VendorFinanceReconciliationFetchConfigEvent
    extends VendorFinanceReconciliationEvent {
  VendorFinanceReconciliationFetchConfigEvent();
}
