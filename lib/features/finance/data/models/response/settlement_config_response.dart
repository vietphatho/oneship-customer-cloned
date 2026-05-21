
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement_config_response.freezed.dart';
part 'settlement_config_response.g.dart';

@freezed
abstract class SettlementConfigResponse with _$SettlementConfigResponse {
  const factory SettlementConfigResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "settlementCycle") String? settlementCycle,
    @JsonKey(name: "dayOfWeek") int? dayOfWeek,
    @JsonKey(name: "dayOfMonth") int? dayOfMonth,
    @JsonKey(name: "autoCreatePeriod") bool? autoCreatePeriod,
    @JsonKey(name: "autoLockDays") int? autoLockDays,
    @JsonKey(name: "bankCode") String? bankCode,
    @JsonKey(name: "bankName") String? bankName,
    @JsonKey(name: "accountNumber") int? accountNumber,
    @JsonKey(name: "accountHolder") String? accountHolder,
    @JsonKey(name: "branch") String? branch,
    @JsonKey(name: "hasBankInfo") bool? hasBankInfo,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _SettlementConfigResponse;

  factory SettlementConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$SettlementConfigResponseFromJson(json);
}
