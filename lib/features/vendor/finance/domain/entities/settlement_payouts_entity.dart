import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:oneship_customer/core/base/models/base_meta_entity.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/settlement_payouts_response.dart';

part 'settlement_payouts_entity.freezed.dart';

@freezed
abstract class SettlementPayoutsEntity with _$SettlementPayoutsEntity {
  const factory SettlementPayoutsEntity({
    List<PayoutEntity>? items,
    BaseMetaEntity? meta,
  }) = _SettlementPayoutsEntity;

  factory SettlementPayoutsEntity.from(SettlementPayoutsResponse dto) =>
      SettlementPayoutsEntity(
        items: dto.items?.map((e) => PayoutEntity.from(e)).toList() ?? [],
        meta: BaseMetaEntity.from(dto.meta!),
      );
}

@freezed
abstract class PayoutEntity with _$PayoutEntity {
  const factory PayoutEntity({
    String? id,
    String? shopId,
    String? type,
    String? periodId,
    int? amount,
    String? status,
    BankInfoEntity? bankInfo,
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
    type: dto.type,
    periodId: dto.periodId,
    amount: dto.amount,
    status: dto.status,
    bankInfo: dto.bankInfo != null ? BankInfoEntity.from(dto.bankInfo!) : null,
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
