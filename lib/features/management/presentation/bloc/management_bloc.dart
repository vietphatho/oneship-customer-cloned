import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';
import 'package:oneship_customer/features/management/domain/repositories/management_repository.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_event.dart';
import 'package:oneship_customer/features/management/presentation/bloc/management_state.dart';

@lazySingleton
class ManagementBloc extends Bloc<ManagementEvent, ManagementState> {
  ManagementBloc(this._repository) : super(ManagementInitState()) {
    on<ManagementGetShopsEvent>(_onGetShops);
  }

  final ManagementRepository _repository;

  late String _userId;

  List<ShopInfo> _shops = [];
  List<ShopInfo> get shops => _shops;

  ShopInfo? _currentShop;
  ShopInfo? get currentShop => _currentShop;

  FutureOr<void> _onGetShops(
    ManagementGetShopsEvent event,
    Emitter<ManagementState> emit,
  ) async {
    emit(ManagementGetShopsState(Resource.loading()));
    final response = await _repository.getShops(_userId);
    _shops = response.data?.data ?? [];
    _currentShop = _shops.firstOrNull;
    emit(ManagementGetShopsState(response));
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  void getShops() {
    add(ManagementGetShopsEvent());
  }
}
