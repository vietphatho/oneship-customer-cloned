import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/use_cases/add_staff_to_shop_use_case.dart';
import 'package:oneship_customer/features/shop_staff/domain/use_cases/create_shop_staff_use_case.dart';
import 'package:oneship_customer/features/shop_staff/domain/use_cases/fetch_shop_staff_detail_use_case.dart';
import 'package:oneship_customer/features/shop_staff/domain/use_cases/fetch_shop_staffs_use_case.dart';
import 'package:oneship_customer/features/shop_staff/domain/use_cases/toggle_disable_shop_staff_use_case.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_event.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';

@lazySingleton
class ShopStaffBloc extends Bloc<ShopStaffEvent, ShopStaffState> {
  ShopStaffBloc(
    this._fetchShopStaffsUseCase,
    this._fetchShopStaffDetailUseCase,
    this._createShopStaffUseCase,
    this._addStaffToShopUseCase,
    this._toggleDisableShopStaffUseCase,
  )
    : super(
        ShopStaffState(
          staffsResource: Resource.loading(),
          createStaffResource: Resource.loading(),
          toggleDisableResource: Resource.loading(),
          staffDetailResource: Resource.loading(),
          addStaffToShopResource: Resource.loading(),
        ),
      ) {
    on<ShopStaffInitEvent>(_onInit);
    on<ShopStaffFetchEvent>(_onFetch);
    on<ShopStaffLoadMoreEvent>(_onLoadMore);
    on<ShopStaffFilterEvent>(_onFilter);
    on<ShopStaffFetchDetailEvent>(_onFetchDetail);
    on<ShopStaffCreateEvent>(_onCreate);
    on<ShopStaffAddToShopEvent>(_onAddToShop);
    on<ShopStaffToggleDisableEvent>(_onToggleDisable);
  }

  final FetchShopStaffsUseCase _fetchShopStaffsUseCase;
  final FetchShopStaffDetailUseCase _fetchShopStaffDetailUseCase;
  final CreateShopStaffUseCase _createShopStaffUseCase;
  final AddStaffToShopUseCase _addStaffToShopUseCase;
  final ToggleDisableShopStaffUseCase _toggleDisableShopStaffUseCase;

  int _page = 1;
  String? _displayName;
  String? _userEmail;
  String? _userStatus;

  FutureOr<void> _onInit(
    ShopStaffInitEvent event,
    Emitter<ShopStaffState> emit,
  ) {
    emit(state.copyWith(currentShop: event.shop));
    add(const ShopStaffFetchEvent(refresh: true));
  }

  FutureOr<void> _onFetch(
    ShopStaffFetchEvent event,
    Emitter<ShopStaffState> emit,
  ) async {
    final shopId = state.currentShop?.shopId;
    if (shopId == null || shopId.isEmpty) {
      emit(
        state.copyWith(
          staffsResource: Resource.success(<ShopStaffEntity>[]),
          staffs: const [],
          total: 0,
          hasMoreData: false,
        ),
      );
      return;
    }

    if (event.refresh) {
      _page = 1;
    }

    emit(state.copyWith(staffsResource: Resource.loading(data: state.staffs)));
    final response = await _fetchShopStaffsUseCase.call(
      shopId: shopId,
      page: _page,
      limit: Constants.defaultLimitPerPage,
      displayName: _displayName,
      userEmail: _userEmail,
      userStatus: _userStatus,
    );

    final nextStaffs =
        event.refresh
            ? response.data?.items ?? []
            : [...state.staffs, ...?response.data?.items];

    emit(
      state.copyWith(
        staffsResource: response.parse((data) => nextStaffs),
        staffs: nextStaffs,
        total: response.data?.meta?.total ?? nextStaffs.length,
        hasMoreData: response.data?.hasMoreData ?? false,
      ),
    );
  }

  FutureOr<void> _onLoadMore(
    ShopStaffLoadMoreEvent event,
    Emitter<ShopStaffState> emit,
  ) {
    if (!state.hasMoreData) return Future.value();
    _page += 1;
    add(const ShopStaffFetchEvent());
  }

  FutureOr<void> _onFilter(
    ShopStaffFilterEvent event,
    Emitter<ShopStaffState> emit,
  ) {
    _displayName = _emptyToNull(event.displayName);
    _userEmail = _emptyToNull(event.userEmail);
    _userStatus = _emptyToNull(event.userStatus);
    add(const ShopStaffFetchEvent(refresh: true));
  }

  FutureOr<void> _onFetchDetail(
    ShopStaffFetchDetailEvent event,
    Emitter<ShopStaffState> emit,
  ) async {
    emit(state.copyWith(staffDetailResource: Resource.loading()));
    final response = await _fetchShopStaffDetailUseCase.call(
      shopId: event.shopId,
      staffId: event.staffId,
    );
    emit(state.copyWith(staffDetailResource: response));
  }

  FutureOr<void> _onCreate(
    ShopStaffCreateEvent event,
    Emitter<ShopStaffState> emit,
  ) async {
    emit(state.copyWith(createStaffResource: Resource.loading()));
    final response = await _createShopStaffUseCase.call(event.request);
    emit(state.copyWith(createStaffResource: response));
    if (response.state == Result.success) {
      add(const ShopStaffFetchEvent(refresh: true));
    }
  }

  FutureOr<void> _onAddToShop(
    ShopStaffAddToShopEvent event,
    Emitter<ShopStaffState> emit,
  ) async {
    emit(state.copyWith(addStaffToShopResource: Resource.loading()));
    final response = await _addStaffToShopUseCase.call(
      shopId: event.shopId,
      userId: event.userId,
      permissions: event.permissions,
    );
    emit(state.copyWith(addStaffToShopResource: response));
  }

  FutureOr<void> _onToggleDisable(
    ShopStaffToggleDisableEvent event,
    Emitter<ShopStaffState> emit,
  ) async {
    emit(state.copyWith(toggleDisableResource: Resource.loading()));
    final response = await _toggleDisableShopStaffUseCase.call(
      shopId: event.shopId,
      staffId: event.staffId,
    );
    emit(state.copyWith(toggleDisableResource: response));
    if (response.state == Result.success) {
      add(const ShopStaffFetchEvent(refresh: true));
    }
  }

  void init(BriefShopEntity shop) {
    add(ShopStaffInitEvent(shop));
  }

  void refresh() {
    add(const ShopStaffFetchEvent(refresh: true));
  }

  void filterStaffs({
    String? displayName,
    String? userEmail,
    String? userStatus,
  }) {
    add(
      ShopStaffFilterEvent(
        displayName: displayName,
        userEmail: userEmail,
        userStatus: userStatus,
      ),
    );
  }

  void loadMore() {
    add(const ShopStaffLoadMoreEvent());
  }

  void fetchDetail({
    required String shopId,
    required String staffId,
  }) {
    add(ShopStaffFetchDetailEvent(shopId: shopId, staffId: staffId));
  }

  void createStaff({
    required String userLogin,
    required String userPass,
    required String displayName,
    required String userEmail,
    required String userPhone,
    required String shopId,
    Map<String, Map<String, bool>>? permissions,
  }) {
    add(
      ShopStaffCreateEvent(
        CreateShopStaffRequest.create(
          userLogin: userLogin,
          userPass: userPass,
          displayName: displayName,
          userEmail: userEmail,
          userPhone: userPhone,
          shopId: shopId,
          permissions: permissions,
        ),
      ),
    );
  }

  void addStaffToShop({
    required String shopId,
    required String userId,
    required Map<String, Map<String, bool>> permissions,
  }) {
    add(
      ShopStaffAddToShopEvent(
        shopId: shopId,
        userId: userId,
        permissions: permissions,
      ),
    );
  }

  void toggleDisableStaff(ShopStaffEntity staff) {
    if (staff.shopId.isEmpty || staff.staffId.isEmpty) return;
    add(
      ShopStaffToggleDisableEvent(
        shopId: staff.shopId,
        staffId: staff.staffId,
      ),
    );
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
