import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/shipping_service_config_response.dart';

part 'shipping_service_config_entity.freezed.dart';

@freezed
abstract class ShippingServiceConfigEntity with _$ShippingServiceConfigEntity {
  const ShippingServiceConfigEntity._();

  const factory ShippingServiceConfigEntity({
    required String id,
    required String serviceCode,
    required String serviceLabel,
    required bool isEnabled,
    required int maxWeightKg,
    ShippingServiceOverflowEntity? weightOverflow,
    ShippingServiceOverflowEntity? distanceOverflow,
    @Default([]) List<PricingMatrixEntity> pricingMatrix,
    @Default([]) List<CoverageRuleEntity> coverageRules,
    required int sortOrder,
    DateTime? updatedAt,
  }) = _ShippingServiceConfigEntity;

  int get baseFee {
    for (final matrix in pricingMatrix) {
      if (matrix.prices.isNotEmpty) {
        return matrix.prices.first.fee;
      }
    }
    return 0;
  }

  bool get hasInfo => pricingMatrix.isNotEmpty || coverageRules.isNotEmpty;

  factory ShippingServiceConfigEntity.from(ShippingService data) {
    return ShippingServiceConfigEntity(
      id: data.id ?? '',
      serviceCode: data.serviceCode ?? '',
      serviceLabel: data.serviceLabel ?? '',
      isEnabled: data.isEnabled ?? false,
      maxWeightKg: data.maxWeightKg ?? 0,
      weightOverflow: data.weightOverflow == null
          ? null
          : ShippingServiceOverflowEntity.from(data.weightOverflow!),
      distanceOverflow: data.distanceOverflow == null
          ? null
          : ShippingServiceOverflowEntity.from(data.distanceOverflow!),
      pricingMatrix:
          data.pricingMatrix?.map(PricingMatrixEntity.from).toList() ?? [],
      coverageRules:
          data.coverageRules?.map(CoverageRuleEntity.from).toList() ?? [],
      sortOrder: data.sortOrder ?? 0,
      updatedAt: data.updatedAt,
    );
  }

  factory ShippingServiceConfigEntity.fromValue(String value) {
    return ShippingServiceConfigEntity(
      id: "",
      serviceCode: value,
      serviceLabel: value,
      isEnabled: true,
      maxWeightKg: 0,
      sortOrder: 0,
    );
  }
}

@freezed
abstract class PricingMatrixEntity with _$PricingMatrixEntity {
  const factory PricingMatrixEntity({
    @Default([]) List<int> provinceLevels,
    @Default([]) List<int> wardLevels,
    required int maxWeightKg,
    @Default([]) List<PricingMatrixPriceEntity> prices,
  }) = _PricingMatrixEntity;

  factory PricingMatrixEntity.from(PricingMatrix data) {
    return PricingMatrixEntity(
      provinceLevels: data.provinceLevels ?? [],
      wardLevels: data.wardLevels ?? [],
      maxWeightKg: data.maxWeightKg ?? 0,
      prices: data.prices?.map(PricingMatrixPriceEntity.from).toList() ?? [],
    );
  }
}

@freezed
abstract class PricingMatrixPriceEntity with _$PricingMatrixPriceEntity {
  const factory PricingMatrixPriceEntity({
    required int maxDistanceKm,
    required int fee,
  }) = _PricingMatrixPriceEntity;

  factory PricingMatrixPriceEntity.from(PricingMatrixPrice data) {
    return PricingMatrixPriceEntity(
      maxDistanceKm: data.maxDistanceKm ?? 0,
      fee: data.fee ?? 0,
    );
  }
}

@freezed
abstract class ShippingServiceOverflowEntity
    with _$ShippingServiceOverflowEntity {
  const factory ShippingServiceOverflowEntity({
    int? maxWeightKg,
    int? maxDistanceKm,
    int? fee,
  }) = _ShippingServiceOverflowEntity;

  factory ShippingServiceOverflowEntity.from(ShippingServiceOverflow data) {
    return ShippingServiceOverflowEntity(
      maxWeightKg: data.maxWeightKg,
      maxDistanceKm: data.maxDistanceKm,
      fee: data.fee,
    );
  }
}

@freezed
abstract class CoverageRuleEntity with _$CoverageRuleEntity {
  const factory CoverageRuleEntity({
    @Default("") String label,
    @Default([]) List<int> provinceLevels,
    @Default([]) List<int> wardLevels,
    int? maxWeightKg,
    int? maxDistanceKm,
    int? fee,
    @Default([]) List<CoverageRuleFeeEntity> fees,
    bool? isEnabled,
  }) = _CoverageRuleEntity;

  factory CoverageRuleEntity.from(CoverageRule data) {
    return CoverageRuleEntity(
      label: data.label ?? "",
      provinceLevels: data.provinceLevels ?? [],
      wardLevels: data.wardLevels ?? [],
      maxWeightKg: data.maxWeightKg,
      maxDistanceKm: data.maxDistanceKm,
      fee: data.fee,
      fees: data.fees?.map(CoverageRuleFeeEntity.from).toList() ?? [],
      isEnabled: data.isEnabled,
    );
  }
}

@freezed
abstract class CoverageRuleFeeEntity with _$CoverageRuleFeeEntity {
  const factory CoverageRuleFeeEntity({
    @Default("") String label,
    required int fee,
  }) = _CoverageRuleFeeEntity;

  factory CoverageRuleFeeEntity.from(CoverageRuleFee data) {
    return CoverageRuleFeeEntity(label: data.label ?? "", fee: data.fee ?? 0);
  }
}

extension ShippingServiceConfigListX on List<ShippingServiceConfigEntity> {
  ShippingServiceConfigEntity? findByServiceCode(String? serviceCode) {
    if (serviceCode == null || serviceCode.isEmpty) return null;

    for (final service in this) {
      if (service.serviceCode == serviceCode) return service;
    }
    return null;
  }
}

enum ShippingServiceDetailType { pricingMatrix, coverageRules, empty }

class ShippingServiceDetailViewModel {
  const ShippingServiceDetailViewModel({
    required this.type,
    this.pricingGroups = const [],
    this.coverageRules = const [],
  });

  final ShippingServiceDetailType type;
  final List<ShippingServicePricingGroupViewModel> pricingGroups;
  final List<ShippingServiceCoverageRuleViewModel> coverageRules;
}

class ShippingServicePricingGroupViewModel {
  const ShippingServicePricingGroupViewModel({
    required this.maxWeightKg,
    required this.rows,
  });

  final int maxWeightKg;
  final List<ShippingServicePricingRowViewModel> rows;

  String get weightLabel => "≤ $maxWeightKg kg";
}

class ShippingServicePricingRowViewModel {
  const ShippingServicePricingRowViewModel({
    required this.minDistanceKm,
    required this.maxDistanceKm,
    required this.fee,
  });

  final int minDistanceKm;
  final int maxDistanceKm;
  final int fee;

  String get distanceLabel => "$minDistanceKm - $maxDistanceKm km";
}

class ShippingServiceCoverageRuleViewModel {
  const ShippingServiceCoverageRuleViewModel({
    required this.label,
    required this.fees,
    required this.maxWeightLabel,
  });

  final String label;
  final List<ShippingServiceCoverageRuleFeeViewModel> fees;
  final String maxWeightLabel;
}

class ShippingServiceCoverageRuleFeeViewModel {
  const ShippingServiceCoverageRuleFeeViewModel({
    required this.label,
    required this.fee,
  });

  final String label;
  final int fee;
}

extension ShippingServiceConfigDetailX on ShippingServiceConfigEntity {
  ShippingServiceDetailViewModel get detailViewModel {
    if (pricingMatrix.isNotEmpty) {
      return ShippingServiceDetailViewModel(
        type: ShippingServiceDetailType.pricingMatrix,
        pricingGroups: _pricingGroups,
      );
    }

    if (coverageRules.isNotEmpty) {
      return ShippingServiceDetailViewModel(
        type: ShippingServiceDetailType.coverageRules,
        coverageRules: _coverageRuleViewModels,
      );
    }

    return const ShippingServiceDetailViewModel(
      type: ShippingServiceDetailType.empty,
    );
  }

  List<ShippingServicePricingGroupViewModel> get _pricingGroups {
    final grouped = groupBy(
      pricingMatrix,
      (PricingMatrixEntity matrix) => matrix.maxWeightKg,
    );
    final weights = grouped.keys.toList()..sort();

    return weights.map((weight) {
      final prices = grouped[weight]!.expand((matrix) => matrix.prices).toList()
        ..sort((a, b) => a.maxDistanceKm.compareTo(b.maxDistanceKm));

      var previousDistance = 0;
      final rows = <ShippingServicePricingRowViewModel>[];
      for (final price in prices) {
        rows.add(
          ShippingServicePricingRowViewModel(
            minDistanceKm: previousDistance,
            maxDistanceKm: price.maxDistanceKm,
            fee: price.fee,
          ),
        );
        previousDistance = price.maxDistanceKm;
      }

      return ShippingServicePricingGroupViewModel(
        maxWeightKg: weight,
        rows: rows,
      );
    }).toList();
  }

  List<ShippingServiceCoverageRuleViewModel> get _coverageRuleViewModels {
    final sortedRules = [...coverageRules]
      ..sort((a, b) {
        final weightCompare = _nullableIntCompare(a.maxWeightKg, b.maxWeightKg);
        if (weightCompare != 0) return weightCompare;
        return _nullableIntCompare(a.maxDistanceKm, b.maxDistanceKm);
      });

    return sortedRules.map((rule) {
      return ShippingServiceCoverageRuleViewModel(
        label: rule.label.isNotEmpty
            ? rule.label
            : _maxWeightLabel(rule.maxWeightKg),
        fees: _coverageRuleFees(rule),
        maxWeightLabel: _maxWeightLabel(rule.maxWeightKg),
      );
    }).toList();
  }

  static List<ShippingServiceCoverageRuleFeeViewModel> _coverageRuleFees(
    CoverageRuleEntity rule,
  ) {
    if (rule.fees.isNotEmpty) {
      return rule.fees
          .map(
            (fee) => ShippingServiceCoverageRuleFeeViewModel(
              label: fee.label,
              fee: fee.fee,
            ),
          )
          .toList();
    }

    if (rule.fee != null) {
      return [
        ShippingServiceCoverageRuleFeeViewModel(
          label: rule.label,
          fee: rule.fee!,
        ),
      ];
    }

    return const [];
  }

  static int _nullableIntCompare(int? a, int? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  static String _maxWeightLabel(int? maxWeightKg) {
    if (maxWeightKg == null) return "Không giới hạn";
    return "≤ $maxWeightKg kg";
  }
}
