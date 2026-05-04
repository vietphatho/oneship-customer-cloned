import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:oneship_customer/features/packages/domain/repositories/packages_repository.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_event.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

@lazySingleton
class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc(this._repository)
    : super(
        PackagesState(
          currentShop: ShopEntity(),
          pkgsData: Resource.loading(),
          currentPkg: Resource.loading(),
          findingShipperResult: Resource.loading(),
          cancelFindingShipperResult: Resource.loading(),
        ),
      ) {
    on<PackageInitEvent>(_onInit);
    on<PackagesFetchingEvent>(_onFetchedPackages);
    on<PackagesViewDetailEvent>(_onViewDetailEvent);
    on<PackagesFindShipperEvent>(_onFindShipperEvent);
    on<PackagesCancelFindingShipperEvent>(_onCancelFindingShipperEvent);
  }

  final PackagesRepository _repository;

  List<Package> _packages = [];
  List<Package> get packages => _packages;

  FutureOr<void> _onInit(PackageInitEvent event, Emitter<PackagesState> emit) {
    emit(state.copyWith(currentShop: event.shop));
  }

  FutureOr<void> _onFetchedPackages(
    PackagesFetchingEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(pkgsData: Resource.loading()));
    final response = await _repository.fetchPackages(shopId: state.shopId);
    _packages = response.data?.data ?? [];
    emit(state.copyWith(pkgsData: response.parse((e) => e.data ?? [])));
  }

  FutureOr<void> _onViewDetailEvent(
    PackagesViewDetailEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(currentPkg: Resource.loading()));
    final response = await _repository.fetchPackageDetail(
      shopId: state.shopId,
      pkgId: event.pkgId,
    );
    emit(state.copyWith(currentPkg: response));
  }

  FutureOr<void> _onFindShipperEvent(
    PackagesFindShipperEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(findingShipperResult: Resource.loading()));
    final response = await _repository.findShipper(state.shopId);
    emit(state.copyWith(findingShipperResult: response));
  }

  FutureOr<void> _onCancelFindingShipperEvent(
    PackagesCancelFindingShipperEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(cancelFindingShipperResult: Resource.loading()));
    final response = await _repository.cancelFindingShipper(state.shopId);
    emit(state.copyWith(cancelFindingShipperResult: response));
  }

  void init(ShopEntity shop) {
    add(PackagesFetchingEvent());
    add(PackageInitEvent(shop));
  }

  void viewPkg(String pkgId) {
    add(PackagesViewDetailEvent(pkgId));
  }

  void findShipper() {
    add(const PackagesFindShipperEvent());
  }

  void cancelfindingShipper() {
    add(const PackagesCancelFindingShipperEvent());
  }
}
