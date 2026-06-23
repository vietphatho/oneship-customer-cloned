import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/visible_surcharges_response.dart';

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
    int? feePercent,
    String? customNote,
    @Default(true) bool isVisibleOnShop,
    @Default([]) List<SurchargeTierEntity> tiers,
  }) = _SurchargeEntity;

  bool get requiresValue => tiers.isNotEmpty;

  SurchargeFeeType get feeTypeEnum => SurchargeFeeTypeX.fromString(feeType);

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

extension SurchargeGroupListX on List<SurchargeGroupEntity> {
  List<SurchargeEntity> get visibleSurcharges =>
      expand((group) => group.surcharges)
          .where(
            (surcharge) => surcharge.isEnabled && surcharge.isVisibleOnShop,
          )
          .toList();

  String? findSurchargeLabel(String? code) {
    if (code == null || code.isEmpty) return null;

    for (final surcharge in visibleSurcharges) {
      if (surcharge.code == code && surcharge.label.isNotEmpty) {
        return surcharge.label;
      }
    }
    return null;
  }
}

extension SurchargeDisplayX on SurchargeEntity {
  String get displayText {
    final value = switch (feeTypeEnum) {
      SurchargeFeeType.fixed =>
        "${feeTypeEnum.displayName.tr()}: ${Utils.formatCurrencyWithUnit(fee)}",
      SurchargeFeeType.percent =>
        "${feeTypeEnum.displayName.tr()}: $_formattedPercent",
      SurchargeFeeType.tiered =>
        tiers.isEmpty
            ? ""
            : "${"from".tr()} ${Utils.formatCurrencyWithUnit(tiers.first.fee)}",
      SurchargeFeeType.negotiable => customNote?.trim() ?? "",
      SurchargeFeeType.unknown => Utils.formatCurrencyWithUnit(fee),
    };

    if (value.isEmpty) return "";
    return value;
  }

  String get _formattedPercent {
    final value = feePercent?.toString().trim();
    if (value == null || value.isEmpty) return "";
    if (value.endsWith("%")) return value;
    return "$value%";
  }
}

class SurchargeDetailViewModel {
  const SurchargeDetailViewModel({required this.tiers});

  final List<SurchargeTierViewModel> tiers;
}

class SurchargeTierViewModel {
  const SurchargeTierViewModel({
    required this.tierLabel,
    required this.rangeLabel,
    required this.feeLabel,
  });

  final String tierLabel;
  final String rangeLabel;
  final String feeLabel;
}

extension SurchargeDetailX on SurchargeEntity {
  SurchargeDetailViewModel get detailViewModel {
    final sortedTiers = [...tiers]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SurchargeDetailViewModel(
      tiers: sortedTiers.map((tier) => tier.detailViewModel).toList(),
    );
  }
}

extension SurchargeTierDetailX on SurchargeTierEntity {
  SurchargeTierViewModel get detailViewModel {
    return SurchargeTierViewModel(
      tierLabel: tierLabel,
      rangeLabel:
          "Từ ${_formatRangeValue(fromValue)} đến ${_formatRangeValue(toValue)}",
      feeLabel: _feeLabel,
    );
  }

  String get _feeLabel {
    final feeTypeEnum = SurchargeFeeTypeX.fromString(feeType);

    if (feeTypeEnum == SurchargeFeeType.percent) {
      final value = fee?.toString().trim();
      if (value == null || value.isEmpty) return "--";
      return value.endsWith("%") ? value : "$value%";
    }

    return Utils.formatCurrencyWithUnit(fee);
  }

  static String _formatRangeValue(int? value) {
    if (value == null) return "--";
    return Utils.formatCurrencyInput(value);
  }
}
