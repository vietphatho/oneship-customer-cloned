import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/error_code.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';
import 'package:oneship_customer/features/vendor/home/domain/entities/vendor_stats_entity.dart';
import 'package:oneship_customer/features/vendor/home/presentation/bloc/vendor_stats_filter.dart';

part 'vendor_stats_state.freezed.dart';

@freezed
abstract class VendorStatsState with _$VendorStatsState {
  const factory VendorStatsState({
    required Resource<VendorStats> statsResource,
    required Resource<VendorFinanceEntity> balanceResource,
    required DateTime startDate,
    required DateTime endDate,
    @Default(VendorStatsFilter.custom) VendorStatsFilter filter,
    @Default(false) bool hasLoadedInitialRange,
  }) = _VendorStatsState;

  factory VendorStatsState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return VendorStatsState(
      statsResource: Resource.loading(),
      balanceResource: Resource.loading(),
      startDate: today,
      endDate: today,
    );
  }
}

extension VendorStatsStateX on VendorStatsState {
  VendorStats? get stats => statsResource.data;

  bool get isLoading => statsResource.state == Result.loading;

  bool get isError => statsResource.state == Result.error;

  VendorFinanceEntity? get balance => balanceResource.data;

  bool get isSecondPasswordVerificationRequired =>
      statsResource.statusCode == 401 &&
      (statsResource.errorCode == ErrorCodeEnum.auth016.key ||
          statsResource.errorCode == ErrorCodeEnum.auth020.key);

  bool get isEmpty =>
      statsResource.state == Result.success && stats?.isEmpty == true;

  String get rangeKey =>
      '${startDate.toIso8601String()}|${endDate.toIso8601String()}';
}
