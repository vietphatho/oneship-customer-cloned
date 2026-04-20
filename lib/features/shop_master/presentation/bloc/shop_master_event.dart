import 'package:oneship_customer/features/shop_master/data/enum.dart';

abstract class ShopMasterEvent {
  const ShopMasterEvent();
}

class ShopMasterChangeMenuTabEvent extends ShopMasterEvent {
  final BottomNavigationItem tab;

  ShopMasterChangeMenuTabEvent(this.tab);
}
