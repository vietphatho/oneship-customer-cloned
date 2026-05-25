import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/core/base/models/base_meta_entity.dart';
import 'package:oneship_shop/features/finance/data/models/response/settlement_periods_response.dart';
import 'package:oneship_shop/features/finance/enum.dart';

part 'settlement_periods_entity.freezed.dart';

@freezed
abstract class SettlementPeriodsEntity with _$SettlementPeriodsEntity {
  factory SettlementPeriodsEntity({
    List<PeriodEntity>? items,
    BaseMetaEntity? meta,
  }) = _SettlementPeriodsEntity;

  factory SettlementPeriodsEntity.from(SettlementPeriodsResponse dto) {
    return SettlementPeriodsEntity(
      items: dto.items?.map((e) => PeriodEntity.from(e)).toList(),
      meta: BaseMetaEntity.from(dto.meta!),
    );
  }
}

@freezed
abstract class PeriodEntity with _$PeriodEntity {
  factory PeriodEntity({
    String? id,
    String? shopId,
    String? periodCode,
    String? periodType,
    String? startedAt,
    String? endedAt,
    String? status,
    int? totalIn,
    int? totalOut,
    int? totalAdjustment,
    int? netPayable,
    int? orderCount,
    int? orderDiscount,

    String? lockedAt,
    String? lockedBy,
    String? approvedAt,
    String? approvedBy,
    String? volumeDiscountTierId,
    String? volumeDiscountTierName,

    int? volumeDiscountPercentage,
    int? volumeDiscountAmount,
    String? createdAt,
  }) = _PeriodEntity;

  factory PeriodEntity.from(Period dto) {
    return PeriodEntity(
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
      lockedAt: dto.lockedAt,
      lockedBy: dto.lockedBy,
      approvedAt: dto.approvedAt,
      approvedBy: dto.approvedBy,
      volumeDiscountTierId: dto.volumeDiscountTierId,
      volumeDiscountTierName: dto.volumeDiscountTierName,
      volumeDiscountPercentage: dto.volumeDiscountPercentage,
      volumeDiscountAmount: dto.volumeDiscountAmount,
      createdAt: dto.createdAt,
    );
  }
}

extension PeriodEntityX on PeriodEntity {
  PeriodStatus get periodStatus => PeriodStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => PeriodStatus.all,
  );
}
