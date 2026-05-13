import 'package:oneship_customer/features/finance/enum.dart';

abstract class FinanceOverviewEvent {
  FinanceOverviewEvent();
}

class FinanceOverviewSelectFilterEvent extends FinanceOverviewEvent {
  final FinanceFilter filter;
  final DateTime startDate;
  final DateTime endDate;

  FinanceOverviewSelectFilterEvent({
    required this.filter,
    required this.startDate,
    required this.endDate,
  });
}

class FinanceOverviewFetchDataEvent extends FinanceOverviewEvent {
  final String shopId;
  final FinanceRequestSource requestSource;
  FinanceOverviewFetchDataEvent({required this.shopId, required this.requestSource});
}
