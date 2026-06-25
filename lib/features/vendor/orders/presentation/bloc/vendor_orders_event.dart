import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';

abstract class VendorOrdersEvent {
  const VendorOrdersEvent();
}

class VendorOrdersInitEvent extends VendorOrdersEvent {
  const VendorOrdersInitEvent();
}

class VendorOrdersFetchedEvent extends VendorOrdersEvent {
  const VendorOrdersFetchedEvent(
    this.tab, {
    this.reset = false,
    this.loadMore = false,
  });

  final VendorOrdersTab tab;
  final bool reset;
  final bool loadMore;
}

class VendorOrdersKeywordChangedEvent extends VendorOrdersEvent {
  const VendorOrdersKeywordChangedEvent({
    required this.tab,
    required this.keyword,
  });

  final VendorOrdersTab tab;
  final String keyword;
}

class VendorOrderDetailFetchedEvent extends VendorOrdersEvent {
  const VendorOrderDetailFetchedEvent({
    required this.orderId,
    required this.tab,
  });

  final String orderId;
  final VendorOrdersTab tab;
}
