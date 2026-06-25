import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/home/data/models/request/vendor_stats_request.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/domain/use_cases/fetch_vendor_stats_use_case.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_event.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_filter.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_state.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

@lazySingleton
class VendorStatsBloc extends Bloc<VendorStatsEvent, VendorStatsState> {
  VendorStatsBloc(this._fetchVendorStatsUseCase, this._vendorProfileBloc)
    : super(VendorStatsState.initial()) {
    on<VendorStatsInitializedEvent>(_onInitialized);
    on<VendorStatsFilterChangedEvent>(_onFilterChanged);
    on<VendorStatsCustomRangeChangedEvent>(_onCustomRangeChanged);
    on<VendorStatsClearedEvent>(_onCleared);
  }

  final FetchVendorStatsUseCase _fetchVendorStatsUseCase;
  final VendorProfileBloc _vendorProfileBloc;
  final Map<String, VendorStats> _statsCache = {};

  FutureOr<void> _onInitialized(
    VendorStatsInitializedEvent event,
    Emitter<VendorStatsState> emit,
  ) async {
    try {
      if (state.hasLoadedInitialRange && !event.forceRefresh) return;
      await _fetchCurrentRange(emit, forceRefresh: event.forceRefresh);
    } finally {
      event.completer?.complete();
    }
  }

  FutureOr<void> _onFilterChanged(
    VendorStatsFilterChangedEvent event,
    Emitter<VendorStatsState> emit,
  ) async {
    final today = _today();
    final range = switch (event.filter) {
      VendorStatsFilter.thisWeek => (
        start: today.subtract(Duration(days: today.weekday - 1)),
        end: today,
      ),
      VendorStatsFilter.thisMonth => (
        start: DateTime(today.year, today.month),
        end: today,
      ),
      VendorStatsFilter.custom => (start: state.startDate, end: state.endDate),
    };

    if (_sameDate(state.startDate, range.start) &&
        _sameDate(state.endDate, range.end) &&
        state.filter == event.filter) {
      return;
    }

    emit(
      state.copyWith(
        filter: event.filter,
        startDate: range.start,
        endDate: range.end,
      ),
    );
    await _fetchCurrentRange(emit);
  }

  FutureOr<void> _onCustomRangeChanged(
    VendorStatsCustomRangeChangedEvent event,
    Emitter<VendorStatsState> emit,
  ) async {
    final startDate = _dateOnly(event.startDate);
    final endDate = _dateOnly(event.endDate);

    if (_sameDate(state.startDate, startDate) &&
        _sameDate(state.endDate, endDate) &&
        state.filter == VendorStatsFilter.custom) {
      return;
    }

    emit(
      state.copyWith(
        filter: VendorStatsFilter.custom,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    await _fetchCurrentRange(emit);
  }

  FutureOr<void> _onCleared(
    VendorStatsClearedEvent event,
    Emitter<VendorStatsState> emit,
  ) {
    _statsCache.clear();
    emit(VendorStatsState.initial());
  }

  Future<void> _fetchCurrentRange(
    Emitter<VendorStatsState> emit, {
    bool forceRefresh = false,
  }) async {
    final owner = await _ownerOrNull();
    if (owner == null) {
      emit(
        state.copyWith(
          statsResource: Resource.error('vendor_profile_not_loaded', 0),
          hasLoadedInitialRange: true,
        ),
      );
      return;
    }

    final request = VendorStatsRequest(
      shopId: owner.shopId,
      vendorId: owner.vendorId,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    final cachedStats = _statsCache[request.cacheKey];
    if (cachedStats != null && !forceRefresh) {
      emit(
        state.copyWith(
          statsResource: Resource.success(cachedStats),
          hasLoadedInitialRange: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        statsResource: Resource.loading(data: state.statsResource.data),
      ),
    );

    final response = await _fetchVendorStatsUseCase(request);
    if (response.state == Result.success && response.data != null) {
      _statsCache[request.cacheKey] = response.data!;
    }

    emit(state.copyWith(statsResource: response, hasLoadedInitialRange: true));
  }

  Future<_VendorStatsOwner?> _ownerOrNull() async {
    var profile = _vendorProfileBloc.profile;
    if (profile == null) {
      _vendorProfileBloc.init();
      profile = await _vendorProfileBloc.stream
          .firstWhere((state) => !state.isLoading)
          .then((state) => state.profile);
    }

    final shopId = profile?.shopId?.trim();
    final vendorId = profile?.id?.trim();
    if (shopId == null ||
        shopId.isEmpty ||
        vendorId == null ||
        vendorId.isEmpty) {
      return null;
    }

    return _VendorStatsOwner(shopId: shopId, vendorId: vendorId);
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _sameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  void init({bool forceRefresh = false}) {
    add(VendorStatsInitializedEvent(forceRefresh: forceRefresh));
  }

  Future<void> refresh() async {
    final completer = Completer<void>();
    add(VendorStatsInitializedEvent(forceRefresh: true, completer: completer));
    return completer.future;
  }

  void changeFilter(VendorStatsFilter filter) {
    add(VendorStatsFilterChangedEvent(filter));
  }

  void changeCustomRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    add(
      VendorStatsCustomRangeChangedEvent(
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  void clear() {
    add(const VendorStatsClearedEvent());
  }
}

class _VendorStatsOwner {
  const _VendorStatsOwner({required this.shopId, required this.vendorId});

  final String shopId;
  final String vendorId;
}
