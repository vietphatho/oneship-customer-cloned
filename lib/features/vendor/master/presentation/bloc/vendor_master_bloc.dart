import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_event.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_state.dart';

@lazySingleton
class VendorMasterBloc extends Bloc<VendorMasterEvent, VendorMasterState> {
  VendorMasterBloc()
    : super(const VendorMasterMenuTabChangedState(VendorNavigationItem.home)) {
    on<VendorMasterChangeMenuTabEvent>(_onTabChanged);
  }

  VendorNavigationItem _currentTab = VendorNavigationItem.home;
  VendorNavigationItem get currentTab => _currentTab;

  FutureOr<void> _onTabChanged(
    VendorMasterChangeMenuTabEvent event,
    Emitter<VendorMasterState> emit,
  ) {
    _currentTab = event.tab;
    emit(VendorMasterMenuTabChangedState(event.tab));
  }

  void changeTab(VendorNavigationItem tab) {
    add(VendorMasterChangeMenuTabEvent(tab));
  }
}
