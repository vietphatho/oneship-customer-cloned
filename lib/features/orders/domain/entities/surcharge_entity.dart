import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/visible_surcharges_response.dart';

part 'surcharge_entity.freezed.dart';

@freezed
abstract class SelectedSurchargeEntity with _$SelectedSurchargeEntity {
  const factory SelectedSurchargeEntity({
    @Default("") String code,
    @Default("") String label,
    int? value,
  }) = _SelectedSurchargeEntity;
}

@freezed
abstract class SurchargeGroupEntity with _$SurchargeGroupEntity {
  const SurchargeGroupEntity._();

  const factory SurchargeGroupEntity({
    @Default("") String group,
    @Default("") String groupName,
    @Default([]) List<SurchargeEntity> surcharges,
  }) = _SurchargeGroupEntity;

  factory SurchargeGroupEntity.from(SurchargeGroupResponse dto) {
    final surcharges =
        dto.surcharges
            .map(SurchargeEntity.from)
            .where((item) => item.code.isNotEmpty)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SurchargeGroupEntity(
      group: dto.group ?? "",
      groupName: dto.groupName ?? dto.group ?? "",
      surcharges: surcharges,
    );
  }
}

@freezed
abstract class SurchargeEntity with _$SurchargeEntity {
  const SurchargeEntity._();

  const factory SurchargeEntity({
    @Default("") String id,
    @Default("") String code,
    @Default("") String label,
    @Default("") String feeType,
    @Default(0) int sortOrder,
    @Default("") String group,
    @Default(true) bool isEnabled,
    int? fee,
    String? feePercent,
    String? customNote,
    @Default(true) bool isVisibleOnShop,
    @Default([]) List<SurchargeTierEntity> tiers,
  }) = _SurchargeEntity;

  bool get requiresValue => tiers.isNotEmpty;

  factory SurchargeEntity.from(SurchargeResponse dto) {
    final tiers = dto.tiers.map(SurchargeTierEntity.from).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SurchargeEntity(
      id: dto.id ?? "",
      code: dto.code ?? "",
      label: dto.label ?? dto.code ?? "",
      feeType: dto.feeType ?? "",
      sortOrder: dto.sortOrder ?? 0,
      group: dto.group ?? "",
      isEnabled: dto.isEnabled ?? true,
      fee: dto.fee,
      feePercent: dto.feePercent,
      customNote: dto.customNote,
      isVisibleOnShop: dto.isVisibleOnShop ?? true,
      tiers: tiers,
    );
  }

  SurchargeTierEntity? matchTier(int value) {
    for (final tier in tiers) {
      if (tier.matches(value)) return tier;
    }
    return null;
  }

  bool isValidValue(int? value) {
    if (!requiresValue) return true;
    if (value == null) return false;
    return matchTier(value) != null;
  }
}

@freezed
abstract class SurchargeTierEntity with _$SurchargeTierEntity {
  const SurchargeTierEntity._();

  const factory SurchargeTierEntity({
    @Default("") String id,
    @Default("") String tierLabel,
    num? fee,
    @Default("") String feeType,
    @Default(0) int sortOrder,
    int? fromValue,
    int? toValue,
  }) = _SurchargeTierEntity;

  factory SurchargeTierEntity.from(SurchargeTierResponse dto) {
    return SurchargeTierEntity(
      id: dto.id ?? "",
      tierLabel: dto.tierLabel ?? "",
      fee: dto.fee ?? 0,
      feeType: dto.feeType ?? "",
      sortOrder: dto.sortOrder ?? 0,
      fromValue: dto.fromValue,
      toValue: dto.toValue,
    );
  }

  bool matches(int value) {
    final isAboveMin = fromValue == null || value >= fromValue!;
    final isBelowMax = toValue == null || value <= toValue!;
    return isAboveMin && isBelowMax;
  }
}
