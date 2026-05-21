import 'package:freezed_annotation/freezed_annotation.dart';

part 'period_detail_response.freezed.dart';
part 'period_detail_response.g.dart';

@freezed
abstract class PeriodDetailResponse with _$PeriodDetailResponse {
  const factory PeriodDetailResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "periodCode") String? periodCode,
    @JsonKey(name: "periodType") String? periodType,
    @JsonKey(name: "startedAt") DateTime? startedAt,
    @JsonKey(name: "endedAt") DateTime? endedAt,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "totalIn") int? totalIn,
    @JsonKey(name: "totalOut") int? totalOut,
    @JsonKey(name: "totalAdjustment") int? totalAdjustment,
    @JsonKey(name: "netPayable") int? netPayable,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "orderDiscount") int? orderDiscount,
    @JsonKey(name: "volumeDiscountTierId") String? volumeDiscountTierId,
    @JsonKey(name: "volumeDiscountTierName") String? volumeDiscountTierName,
    @JsonKey(name: "volumeDiscountPercentage") int? volumeDiscountPercentage,
    @JsonKey(name: "volumeDiscountAmount") int? volumeDiscountAmount,
    @JsonKey(name: "lockedAt") DateTime? lockedAt,
    @JsonKey(name: "lockedBy") String? lockedBy,
    @JsonKey(name: "approvedAt") DateTime? approvedAt,
    @JsonKey(name: "approvedBy") String? approvedBy,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "dailyBreakdown") List<DailyBreakdown>? dailyBreakdown,
    @JsonKey(name: "statusHistory") List<StatusHistory>? statusHistory,
    @JsonKey(name: "payout") Payout? payout,
    @JsonKey(name: "shopName") String? shopName,
  }) = _PeriodDetailResponse;

  factory PeriodDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PeriodDetailResponseFromJson(json);
}

@freezed
abstract class DailyBreakdown with _$DailyBreakdown {
  const factory DailyBreakdown({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "date") DateTime? date,
    @JsonKey(name: "totalIn") int? totalIn,
    @JsonKey(name: "codCollected") int? codCollected,
    @JsonKey(name: "totalOut") int? totalOut,
    @JsonKey(name: "netAmount") int? netAmount,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "returnedOrderCount") int? returnedOrderCount,
  }) = _DailyBreakdown;

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$DailyBreakdownFromJson(json);
}

@freezed
abstract class Payout with _$Payout {
  const factory Payout({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "periodId") String? periodId,
    @JsonKey(name: "amount") int? amount,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "bankInfo") BankInfo? bankInfo,
    @JsonKey(name: "transactionRef") String? transactionRef,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
    @JsonKey(name: "initiatedAt") DateTime? initiatedAt,
    @JsonKey(name: "initiatedBy") String? initiatedBy,
    @JsonKey(name: "paidAt") DateTime? paidAt,
    @JsonKey(name: "failedAt") dynamic failedAt,
    @JsonKey(name: "failureReason") dynamic failureReason,
    @JsonKey(name: "retryCount") int? retryCount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _Payout;

  factory Payout.fromJson(Map<String, dynamic> json) => _$PayoutFromJson(json);
}

@freezed
abstract class BankInfo with _$BankInfo {
  const factory BankInfo({
    @JsonKey(name: "bankCode") String? bankCode,
    @JsonKey(name: "bankName") String? bankName,
    @JsonKey(name: "accountNumber") String? accountNumber,
    @JsonKey(name: "accountHolder") String? accountHolder,
    @JsonKey(name: "branch") String? branch,
  }) = _BankInfo;

  factory BankInfo.fromJson(Map<String, dynamic> json) =>
      _$BankInfoFromJson(json);
}

@freezed
abstract class StatusHistory with _$StatusHistory {
  const factory StatusHistory({
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "changedAt") DateTime? changedAt,
    @JsonKey(name: "changedBy") String? changedBy,
  }) = _StatusHistory;

  factory StatusHistory.fromJson(Map<String, dynamic> json) =>
      _$StatusHistoryFromJson(json);
}
