import 'package:oneship_customer/features/vendor_home/presentation/bloc/vendor_home_order_tab.dart';

abstract class VendorHomeEvent {
  const VendorHomeEvent();
}

class VendorHomeInitEvent extends VendorHomeEvent {
  const VendorHomeInitEvent();
}

class VendorHomeOrdersFetchedEvent extends VendorHomeEvent {
  const VendorHomeOrdersFetchedEvent(this.tab);

  final VendorHomeOrderTab tab;
}

class VendorHomeOrderKeywordChangedEvent extends VendorHomeEvent {
  const VendorHomeOrderKeywordChangedEvent({
    required this.tab,
    required this.keyword,
  });

  final VendorHomeOrderTab tab;
  final String keyword;
}
