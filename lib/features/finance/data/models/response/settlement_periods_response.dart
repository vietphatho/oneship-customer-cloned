import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement_periods_response.freezed.dart';
part 'settlement_periods_response.g.dart';

@freezed
abstract class SettlementPeriodsResponse with _$SettlementPeriodsResponse {
  factory SettlementPeriodsResponse({
    @JsonKey(name: "items") List<Period>? items,
    @JsonKey(name: "meta") Pagination? meta,
  }) = _SettlementPeriodsResponse;

  factory SettlementPeriodsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettlementPeriodsResponseFromJson(json);
}

@freezed
abstract class Period with _$Period {
  factory Period({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "periodCode") String? periodCode,
    @JsonKey(name: "periodType") String? periodType,
    @JsonKey(name: "startedAt") String? startedAt,
    @JsonKey(name: "endedAt") String? endedAt,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "totalIn") int? totalIn,
    @JsonKey(name: "totalOut") int? totalOut,
    @JsonKey(name: "totalAdjustment") int? totalAdjustment,
    @JsonKey(name: "netPayable") int? netPayable,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "orderDiscount") int? orderDiscount,

    @JsonKey(name: "lockedAt") String? lockedAt,
    @JsonKey(name: "lockedBy") String? lockedBy,
    @JsonKey(name: "approvedAt") String? approvedAt,
    @JsonKey(name: "approvedBy") String? approvedBy,
    @JsonKey(name: "volumeDiscountTierId") String? volumeDiscountTierId,
    @JsonKey(name: "volumeDiscountTierName") String? volumeDiscountTierName,

    @JsonKey(name: "volumeDiscountPercentage") int? volumeDiscountPercentage,
    @JsonKey(name: "volumeDiscountAmount") int? volumeDiscountAmount,
    @JsonKey(name: "createdAt") String? createdAt,
  }) = _Period;

  factory Period.fromJson(Map<String, dynamic> json) =>
      _$PeriodFromJson(json);
}

@freezed
abstract class Pagination with _$Pagination {
  factory Pagination({
    @JsonKey(name: "page") int? page,
    @JsonKey(name: "limit") int? limit,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "hasPrevious") bool? hasPrevious,
    @JsonKey(name: "hasNext") bool? hasNext,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}