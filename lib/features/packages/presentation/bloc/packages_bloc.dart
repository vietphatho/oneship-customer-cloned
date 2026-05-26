import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/services/socket_service.dart';
import 'package:oneship_customer/core/utils/app_logger.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/packages/domain/repositories/packages_repository.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_event.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

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

    on<PackagesFindingShipperStatusEvent>(_onFindShipperStatus);
    // on<PackagesFindingShipperFailedEvent>(_onFindShipperFailed);
  }

  final PackagesRepository _repository;

  final SocketService _socketService = getIt<SocketService>();
  SocketService get socketService => _socketService;

  StreamSubscription? _socketSubscription;

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
      emit(state.copyWith(pkgsData: response.data?.data ?? []));
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

  FutureOr<void> _onFindShipperStatus(
    PackagesFindingShipperStatusEvent event,
    Emitter<PackagesState> emit,
  ) {
    emit(state.copyWith(findShipperStatus: event.status));
    disconnectSocket();
    emit(state.copyWith(findShipperStatus: null));
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

  void _listenSocketStream() {
    _socketSubscription?.cancel();
    _socketSubscription = _socketService.stream.listen((message) {
      switch (message.event) {
        case SocketEvent.pkgStatusChanged:
          add(PackagesFindingShipperStatusEvent(true));
          break;
        case SocketEvent.autoDispatchFailed:
          add(const PackagesCancelFindingShipperEvent());
          add(PackagesFindingShipperStatusEvent(false));
          break;
      }
    });
  }

  void connectSocket() async {
    var shopId = state.currentShop.shopId ?? "";
    await _socketService.connect(shopId);
    _listenSocketStream();
    AppLogger().log("🔌 connect socket");
  }

  void disconnectSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _socketService.disconnect();
    AppLogger().log("🔌 disconnect socket");
  }
}
