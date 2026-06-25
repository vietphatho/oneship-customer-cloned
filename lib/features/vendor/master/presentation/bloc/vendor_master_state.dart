import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';

abstract class VendorMasterState {
  const VendorMasterState();
}

class VendorMasterMenuTabChangedState extends VendorMasterState {
  const VendorMasterMenuTabChangedState(this.tab);

  final VendorNavigationItem tab;
}
