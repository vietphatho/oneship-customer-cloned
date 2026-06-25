import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_stats_response.freezed.dart';
part 'vendor_stats_response.g.dart';

@freezed
abstract class VendorStatsResponse with _$VendorStatsResponse {
  const factory VendorStatsResponse({
    @JsonKey(name: 'orderCount') int? orderCount,
    @JsonKey(name: 'totalDeliveryFeeAmount') double? totalDeliveryFeeAmount,
    @JsonKey(name: 'totalCodAmount') double? totalCodAmount,
    @JsonKey(name: 'deliveredCount') int? deliveredCount,
    @JsonKey(name: 'returnedCount') int? returnedCount,
    @JsonKey(name: 'successRate') double? successRate,
    @JsonKey(name: 'dailyStats') List<DailyVendorStatResponse>? dailyStats,
  }) = _VendorStatsResponse;

  factory VendorStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorStatsResponseFromJson(json);
}

@freezed
abstract class DailyVendorStatResponse with _$DailyVendorStatResponse {
  const factory DailyVendorStatResponse({
    @JsonKey(name: 'statDate') DateTime? statDate,
    @JsonKey(name: 'orderCount') int? orderCount,
    @JsonKey(name: 'totalDeliveryFeeAmount') double? totalDeliveryFeeAmount,
    @JsonKey(name: 'totalCodAmount') double? totalCodAmount,
    @JsonKey(name: 'deliveredCount') int? deliveredCount,
    @JsonKey(name: 'returnedCount') int? returnedCount,
    @JsonKey(name: 'successRate') double? successRate,
  }) = _DailyVendorStatResponse;

  factory DailyVendorStatResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyVendorStatResponseFromJson(json);
}
