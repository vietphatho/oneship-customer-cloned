import 'package:oneship_shop/features/shop_master/data/enum.dart';

abstract class ShopMasterState {
  const ShopMasterState();
}

class ShopMasterMenuTabChangedState extends ShopMasterState {
  final BottomNavigationItem tab;

  const ShopMasterMenuTabChangedState(this.tab);
}
