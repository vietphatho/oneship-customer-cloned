import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_event.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_state.dart';

@lazySingleton
class ShopMasterBloc extends Bloc<ShopMasterEvent, ShopMasterState> {
  ShopMasterBloc()
    : super(const ShopMasterMenuTabChangedState(BottomNavigationItem.home)) {
    on<ShopMasterChangeMenuTabEvent>(_onTabChanged);
  }

  BottomNavigationItem _currentTab = BottomNavigationItem.home;
  BottomNavigationItem get currentTab => _currentTab;

  FutureOr<void> _onTabChanged(
    ShopMasterChangeMenuTabEvent event,
    Emitter<ShopMasterState> emit,
  ) {
    _currentTab = event.tab;
    emit(ShopMasterMenuTabChangedState(event.tab));
  }

  void changeTab(BottomNavigationItem tab) {
    add(ShopMasterChangeMenuTabEvent(tab));
  }
}
