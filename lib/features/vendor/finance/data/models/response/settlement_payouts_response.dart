import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'settlement_payouts_response.freezed.dart';
part 'settlement_payouts_response.g.dart';

@freezed
abstract class SettlementPayoutsResponse with _$SettlementPayoutsResponse {
  const factory SettlementPayoutsResponse({
    @JsonKey(name: "items") List<Payout>? items,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _SettlementPayoutsResponse;

  factory SettlementPayoutsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettlementPayoutsResponseFromJson(json);
}

@freezed
abstract class Payout with _$Payout {
  const factory Payout({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "type") String? type,
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
