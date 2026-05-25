import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/features/finance/data/models/response/settlement_config_response.dart';

part 'settlement_config_entity.freezed.dart';

@freezed
abstract class SettlementConfigEntity with _$SettlementConfigEntity {
  const factory SettlementConfigEntity({
    String? id,
    String? shopId,
    String? settlementCycle,
    int? dayOfWeek,
    int? dayOfMonth,
    bool? autoCreatePeriod,
    int? autoLockDays,
    String? bankCode,
    String? bankName,
    int? accountNumber,
    String? accountHolder,
    String? branch,
    bool? hasBankInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SettlementConfigEntity;

  factory SettlementConfigEntity.from(SettlementConfigResponse dto) =>
      SettlementConfigEntity(
        id: dto.id,
        shopId: dto.shopId,
        settlementCycle: dto.settlementCycle,
        dayOfWeek: dto.dayOfWeek,
        dayOfMonth: dto.dayOfMonth,
        autoCreatePeriod: dto.autoCreatePeriod,
        autoLockDays: dto.autoLockDays,
        bankCode: dto.bankCode,
        bankName: dto.bankName,
        accountNumber: dto.accountNumber,
        accountHolder: dto.accountHolder,
        branch: dto.branch,
        hasBankInfo: dto.hasBankInfo,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );
}
