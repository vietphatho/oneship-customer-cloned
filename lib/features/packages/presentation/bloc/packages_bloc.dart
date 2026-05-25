import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/packages/domain/repositories/packages_repository.dart';
import 'package:oneship_shop/features/packages/presentation/bloc/packages_event.dart';
import 'package:oneship_shop/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/get_brief_shops_entity.dart';

@lazySingleton
class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc(this._repository)
    : super(
        PackagesState(
          currentShop: BriefShopEntity(),
          pkgsDataResource: Resource.loading(),
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
    on<PackagesLoadMoreEvent>(_onLoadMorePackages);
  }

  final PackagesRepository _repository;

  FutureOr<void> _onInit(PackageInitEvent event, Emitter<PackagesState> emit) {
    emit(state.copyWith(currentShop: event.shop));
  }

  FutureOr<void> _onFetchedPackages(
    PackagesFetchingEvent event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(pkgsDataResource: Resource.loading()));

    final response = await _repository.fetchPackages(shopId: state.shopId);

    if (response.state == Result.success) {
      emit(
        state.copyWith(
          pkgsData: response.data?.data ?? [],
        ),
      );
    }

    emit(state.copyWith(pkgsDataResource: response));
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

  FutureOr<void> _onLoadMorePackages(
    PackagesLoadMoreEvent event,
    Emitter<PackagesState> emit,
  ) async {
    final meta = state.pkgsDataResource.data?.meta;

    if (meta == null || meta.hasNext == false) return;

    emit(state.copyWith(pkgsDataResource: Resource.loading()));

    final response = await _repository.fetchPackages(
      shopId: state.shopId,
      page: (meta.page ?? 0) + 1,
    );

    if (response.state == Result.success) {
      emit(
        state.copyWith(
          pkgsData: [...state.pkgsData, ...(response.data?.data ?? [])],
        ),
      );
    }

    emit(state.copyWith(pkgsDataResource: response));
  }

  void init(BriefShopEntity shop) {
    add(PackageInitEvent(shop));
    add(PackagesFetchingEvent());
  }

  void fetchPackages() {
    add(PackagesFetchingEvent());
  }

  void loadMorePackages() {
    add(PackagesLoadMoreEvent());
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
