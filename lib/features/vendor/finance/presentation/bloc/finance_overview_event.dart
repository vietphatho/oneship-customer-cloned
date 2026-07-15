import 'package:oneship_customer/features/vendor/finance/enum.dart';

abstract class VendorFinanceOverviewEvent {
  VendorFinanceOverviewEvent();
}

class VendorFinanceOverviewSelectFilterEvent
    extends VendorFinanceOverviewEvent {
  final VendorFinanceFilter filter;
  final DateTime startDate;
  final DateTime endDate;

  VendorFinanceOverviewSelectFilterEvent({
    required this.filter,
    required this.startDate,
    required this.endDate,
  });
}

class VendorFinanceOverviewFetchDataEvent extends VendorFinanceOverviewEvent {
  final String userId;
  final VendorFinanceRequestSource requestSource;
  VendorFinanceOverviewFetchDataEvent({
    required this.userId,
    required this.requestSource,
  });
}
