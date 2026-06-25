import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';

abstract class VendorMasterEvent {
  const VendorMasterEvent();
}

class VendorMasterChangeMenuTabEvent extends VendorMasterEvent {
  const VendorMasterChangeMenuTabEvent(this.tab);

  final VendorNavigationItem tab;
}
