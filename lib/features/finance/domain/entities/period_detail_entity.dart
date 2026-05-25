import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/features/finance/data/models/response/period_detail_response.dart';
import 'package:oneship_shop/features/finance/enum.dart';

part 'period_detail_entity.freezed.dart';

@freezed
abstract class PeriodDetailEntity with _$PeriodDetailEntity {
  const factory PeriodDetailEntity({
    String? id,
    String? shopId,
    String? periodCode,
    String? periodType,
    DateTime? startedAt,
    DateTime? endedAt,
    String? status,
    int? totalIn,
    int? totalOut,
    int? totalAdjustment,
    int? netPayable,
    int? orderCount,
    int? orderDiscount,
    String? volumeDiscountTierId,
    String? volumeDiscountTierName,
    int? volumeDiscountPercentage,
    int? volumeDiscountAmount,
    DateTime? lockedAt,
    String? lockedBy,
    DateTime? approvedAt,
    String? approvedBy,
    DateTime? createdAt,
    List<DailyBreakdownEntity>? dailyBreakdown,
    List<StatusHistoryEntity>? statusHistory,
    PayoutEntity? payout,
    String? shopName,
  }) = _PeriodDetailEntity;

  factory PeriodDetailEntity.from(
    PeriodDetailResponse dto,
  ) => PeriodDetailEntity(
    id: dto.id,
    shopId: dto.shopId,
    periodCode: dto.periodCode,
    periodType: dto.periodType,
    startedAt: dto.startedAt,
    endedAt: dto.endedAt,
    status: dto.status,
    totalIn: dto.totalIn,
    totalOut: dto.totalOut,
    totalAdjustment: dto.totalAdjustment,
    netPayable: dto.netPayable,
    orderCount: dto.orderCount,
    orderDiscount: dto.orderDiscount,
    volumeDiscountTierId: dto.volumeDiscountTierId,
    volumeDiscountTierName: dto.volumeDiscountTierName,
    volumeDiscountPercentage: dto.volumeDiscountPercentage,
    volumeDiscountAmount: dto.volumeDiscountAmount,
    lockedAt: dto.lockedAt,
    lockedBy: dto.lockedBy,
    approvedAt: dto.approvedAt,
    approvedBy: dto.approvedBy,
    createdAt: dto.createdAt,
    dailyBreakdown:
        dto.dailyBreakdown?.map((e) => DailyBreakdownEntity.from(e)).toList() ??
        [],
    statusHistory:
        dto.statusHistory?.map((e) => StatusHistoryEntity.from(e)).toList() ??
        [],
    payout:
        dto.payout != null ? PayoutEntity.from(dto.payout!) : PayoutEntity(),
    shopName: dto.shopName,
  );
}

extension PeriodDetailEntityX on PeriodDetailEntity {
  PeriodStatus get periodStatus => PeriodStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => PeriodStatus.all,
  );
}

@freezed
abstract class DailyBreakdownEntity with _$DailyBreakdownEntity {
  const factory DailyBreakdownEntity({
    String? id,
    DateTime? date,
    int? totalIn,
    int? codCollected,
    int? totalOut,
    int? netAmount,
    int? orderCount,
    int? returnedOrderCount,
  }) = _DailyBreakdownEntity;

  factory DailyBreakdownEntity.from(DailyBreakdown dto) => DailyBreakdownEntity(
    id: dto.id,
    date: dto.date,
    totalIn: dto.totalIn,
    codCollected: dto.codCollected,
    totalOut: dto.totalOut,
    netAmount: dto.netAmount,
    orderCount: dto.orderCount,
    returnedOrderCount: dto.returnedOrderCount,
  );
}

@freezed
abstract class PayoutEntity with _$PayoutEntity {
  const factory PayoutEntity({
    String? id,
    String? shopId,
    String? periodId,
    int? amount,
    String? status,
    BankInfo? bankInfo,
    String? transactionRef,
    String? paymentMethod,
    DateTime? initiatedAt,
    String? initiatedBy,
    DateTime? paidAt,
    dynamic failedAt,
    dynamic failureReason,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PayoutEntity;

  factory PayoutEntity.from(Payout dto) => PayoutEntity(
    id: dto.id,
    shopId: dto.shopId,
    periodId: dto.periodId,
    amount: dto.amount,
    status: dto.status,
    bankInfo: dto.bankInfo,
    transactionRef: dto.transactionRef,
    paymentMethod: dto.paymentMethod,
    initiatedAt: dto.initiatedAt,
    initiatedBy: dto.initiatedBy,
    paidAt: dto.paidAt,
    failedAt: dto.failedAt,
    failureReason: dto.failureReason,
    retryCount: dto.retryCount,
    createdAt: dto.createdAt,
    updatedAt: dto.updatedAt,
  );
}

@freezed
abstract class BankInfoEntity with _$BankInfoEntity {
  const factory BankInfoEntity({
    String? bankCode,
    String? bankName,
    String? accountNumber,
    String? accountHolder,
    String? branch,
  }) = _BankInfoEntity;

  factory BankInfoEntity.from(BankInfo dto) => BankInfoEntity(
    bankCode: dto.bankCode,
    bankName: dto.bankName,
    accountNumber: dto.accountNumber,
    accountHolder: dto.accountHolder,
    branch: dto.branch,
  );
}

@freezed
abstract class StatusHistoryEntity with _$StatusHistoryEntity {
  const factory StatusHistoryEntity({
    String? status,
    DateTime? changedAt,
    String? changedBy,
  }) = _StatusHistoryEntity;

  factory StatusHistoryEntity.from(StatusHistory dto) => StatusHistoryEntity(
    status: dto.status,
    changedAt: dto.changedAt,
    changedBy: dto.changedBy,
  );
}
