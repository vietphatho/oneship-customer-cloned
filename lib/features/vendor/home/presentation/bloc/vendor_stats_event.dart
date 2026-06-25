import 'dart:async';

import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_filter.dart';

abstract class VendorStatsEvent {
  const VendorStatsEvent();
}

class VendorStatsInitializedEvent extends VendorStatsEvent {
  const VendorStatsInitializedEvent({
    this.forceRefresh = false,
    this.completer,
  });

  final bool forceRefresh;
  final Completer<void>? completer;
}

class VendorStatsFilterChangedEvent extends VendorStatsEvent {
  const VendorStatsFilterChangedEvent(this.filter);

  final VendorStatsFilter filter;
}

class VendorStatsCustomRangeChangedEvent extends VendorStatsEvent {
  const VendorStatsCustomRangeChangedEvent({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}

class VendorStatsClearedEvent extends VendorStatsEvent {
  const VendorStatsClearedEvent();
}
