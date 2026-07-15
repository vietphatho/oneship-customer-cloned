import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/finance/domain/use_cases/fetch_vendor_financial_summary_use_case.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_event.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_filter.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_state.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_bloc.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

@lazySingleton
class VendorStatsBloc extends Bloc<VendorStatsEvent, VendorStatsState> {
  VendorStatsBloc(
    this._fetchVendorFinancialSummaryUseCase,
    this._vendorProfileBloc,
  ) : super(VendorStatsState.initial()) {
    on<VendorStatsInitializedEvent>(_onInitialized);
    on<VendorStatsFilterChangedEvent>(_onFilterChanged);
    on<VendorStatsCustomRangeChangedEvent>(_onCustomRangeChanged);
    on<VendorStatsClearedEvent>(_onCleared);
  }

  final FetchVendorFinancialSummaryUseCase _fetchVendorFinancialSummaryUseCase;
  final VendorProfileBloc _vendorProfileBloc;
  final Map<String, VendorStats> _statsCache = {};
  final Map<String, VendorFinanceEntity> _balanceCache = {};

  FutureOr<void> _onInitialized(
    VendorStatsInitializedEvent event,
    Emitter<VendorStatsState> emit,
  ) async {
    try {
      if (state.hasLoadedInitialRange && _isTodayRange && !event.forceRefresh) {
        return;
      }
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
    _balanceCache.clear();
    emit(VendorStatsState.initial());
  }

  Future<void> _fetchCurrentRange(
    Emitter<VendorStatsState> emit, {
    bool forceRefresh = false,
  }) async {
    final today = _today();
    if (!_sameDate(state.startDate, today) ||
        !_sameDate(state.endDate, today)) {
      emit(
        state.copyWith(
          startDate: today,
          endDate: today,
          filter: VendorStatsFilter.custom,
        ),
      );
    }

    final userId = await _userIdOrNull();
    if (userId == null) {
      emit(
        state.copyWith(
          statsResource: Resource.error('vendor_profile_not_loaded', 0),
          balanceResource: Resource.error('vendor_profile_not_loaded', 0),
          hasLoadedInitialRange: true,
        ),
      );
      return;
    }

    final cacheKey = '$userId|${today.toIso8601String()}';
    final statsCacheKey = cacheKey;
    final balanceCacheKey = cacheKey;
    final cachedStats = _statsCache[statsCacheKey];
    final cachedBalance = _balanceCache[balanceCacheKey];
    if (cachedStats != null && cachedBalance != null && !forceRefresh) {
      emit(
        state.copyWith(
          statsResource: Resource.success(cachedStats),
          balanceResource: Resource.success(cachedBalance),
          hasLoadedInitialRange: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        statsResource: Resource.loading(data: state.statsResource.data),
        balanceResource: Resource.loading(data: state.balanceResource.data),
      ),
    );

    final summaryResponse = await _fetchVendorFinancialSummaryUseCase(
      userId: userId,
      startDate: today,
      endDate: today,
    );

    final statsResponse = summaryResponse.parse(
      (entity) => VendorStats.fromFinanceSummary(entity, date: today),
    );
    if (statsResponse.state == Result.success && statsResponse.data != null) {
      _statsCache[statsCacheKey] = statsResponse.data!;
    }
    if (summaryResponse.state == Result.success &&
        summaryResponse.data != null) {
      _balanceCache[balanceCacheKey] = summaryResponse.data!;
    }

    emit(
      state.copyWith(
        statsResource: statsResponse,
        balanceResource: summaryResponse,
        hasLoadedInitialRange: true,
      ),
    );
  }

  Future<String?> _userIdOrNull() async {
    var profile = _vendorProfileBloc.profile;
    if (profile == null) {
      _vendorProfileBloc.init();
      profile = await _vendorProfileBloc.stream
          .firstWhere((state) => !state.isLoading)
          .then((state) => state.profile);
    }

    final userId = profile?.userId?.trim();
    if (userId == null || userId.isEmpty) {
      return null;
    }

    return userId;
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

  bool get _isTodayRange {
    final today = _today();
    return _sameDate(state.startDate, today) && _sameDate(state.endDate, today);
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
