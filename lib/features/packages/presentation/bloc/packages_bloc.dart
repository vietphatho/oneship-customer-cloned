import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:oneship_customer/features/packages/domain/repositories/packages_repository.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_event.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';

@lazySingleton
class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc(this._repository)
    : super(
        PackagesState(
          pkgsData: Resource.loading(),
          currentPkg: Resource.loading(),
          findingShipperResult: Resource.loading(),
          cancelFindingShipperResult: Resource.loading(),
        ),
      ) {
    on<PackagesFetchingEvent>(_onFetchedPackages);
    on<PackagesViewDetailEvent>(_onViewDetailEvent);
    on<PackagesFindShipperEvent>(_onFindShipperEvent);
    on<PackagesCancelFindingShipperEvent>(_onCancelFindingShipperEvent);
  }

  final PackagesRepository _repository;

  late String _shopId;

  List<Package> _packages = [];
  List<Package> get packages => _packages;

  FutureOr<void> _onFetchedPackages(
    PackagesFetchingEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(pkgsData: Resource.loading()));
    final response = await _repository.fetchPackages(shopId: _shopId);
    _packages = response.data?.data ?? [];
    emit(state.copyWith(pkgsData: response.parse((e) => e.data ?? [])));
  }

  FutureOr<void> _onViewDetailEvent(
    PackagesViewDetailEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(currentPkg: Resource.loading()));
    final response = await _repository.fetchPackageDetail(
      shopId: _shopId,
      pkgId: event.pkgId,
    );
    emit(state.copyWith(currentPkg: response));
  }

  FutureOr<void> _onFindShipperEvent(
    PackagesFindShipperEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(findingShipperResult: Resource.loading()));
    final response = await _repository.findShipper(_shopId);
    emit(state.copyWith(findingShipperResult: response));
  }

  FutureOr<void> _onCancelFindingShipperEvent(
    PackagesCancelFindingShipperEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(cancelFindingShipperResult: Resource.loading()));
    final response = await _repository.cancelFindingShipper(_shopId);
    emit(state.copyWith(cancelFindingShipperResult: response));
  }

  void init(String shopId) {
    _shopId = shopId;
    add(PackagesFetchingEvent());
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
