import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';

abstract class VendorOrdersEvent {
  const VendorOrdersEvent();
}

class VendorOrdersInitEvent extends VendorOrdersEvent {
  const VendorOrdersInitEvent();
}

class VendorOrdersFetchedEvent extends VendorOrdersEvent {
  const VendorOrdersFetchedEvent(this.tab);

  final VendorOrdersTab tab;
}

class VendorOrdersKeywordChangedEvent extends VendorOrdersEvent {
  const VendorOrdersKeywordChangedEvent({
    required this.tab,
    required this.keyword,
  });

  final VendorOrdersTab tab;
  final String keyword;
}
