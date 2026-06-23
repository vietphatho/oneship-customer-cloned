import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';

part 'order_fee_entity.freezed.dart';

@freezed
abstract class OrderFeeEntity with _$OrderFeeEntity {
  const OrderFeeEntity._();

  const factory OrderFeeEntity({
    String? id,
    String? shopId,
    String? orderId,
    String? feeGroup,
    String? feeSubtype,
    @Default(0) int baseAmount,
    @Default(0) int vatRate,
    @Default(0) int vatAmount,
    @Default(0) int totalAmount,
    OrderFeeSnapshotEntity? snapshot,
    int? value,
    String? feeType,
    DateTime? createdAt,
  }) = _OrderFeeEntity;

  factory OrderFeeEntity.from(OrderFee dto) {
    return OrderFeeEntity(
      id: dto.id,
      shopId: dto.shopId,
      orderId: dto.orderId,
      feeGroup: dto.feeGroup,
      feeSubtype: dto.feeSubtype,
      baseAmount: dto.baseAmount ?? 0,
      vatRate: dto.vatRate ?? 0,
      vatAmount: dto.vatAmount ?? 0,
      totalAmount: dto.totalAmount ?? 0,
      snapshot: dto.snapshot != null
          ? OrderFeeSnapshotEntity.from(dto.snapshot!)
          : null,
      value: dto.value,
      feeType: dto.feeType,
      createdAt: dto.createdAt,
    );
  }
}

@freezed
abstract class OrderFeeSnapshotEntity with _$OrderFeeSnapshotEntity {
  const factory OrderFeeSnapshotEntity({String? name, int? feePercent}) =
      _OrderFeeSnapshotEntity;

  factory OrderFeeSnapshotEntity.from(OrderFeeSnapshot dto) {
    return OrderFeeSnapshotEntity(name: dto.name, feePercent: dto.feePercent);
  }
}

extension OrderFeeSurchargeMapper on List<OrderFeeEntity> {
  List<OrderFeeEntity> get surchargeFees => where(
    (fee) =>
        fee.feeGroup == 'SURCHARGE' && (fee.feeSubtype?.isNotEmpty ?? false),
  ).toList();

  List<String> get surchargeCodes {
    final codes = <String>[];
    for (final fee in surchargeFees) {
      final code = fee.feeSubtype;
      if (code != null && !codes.contains(code)) {
        codes.add(code);
      }
    }
    return codes;
  }

  Map<String, int> get surchargeValues {
    final values = <String, int>{};
    for (final fee in surchargeFees) {
      final code = fee.feeSubtype;
      final value = fee.value;
      if (code != null && value != null) {
        values[code] = value;
      }
    }
    return values;
  }
}

class OrderFeeDisplayEntity {
  const OrderFeeDisplayEntity({
    required this.label,
    required this.baseAmount,
    required this.vatRate,
    required this.vatAmount,
    required this.totalAmount,
  });

  final String label;
  final int baseAmount;
  final int vatRate;
  final int vatAmount;
  final int totalAmount;
}

extension OrderFeeDisplayMapper on OrderFeeEntity {
  OrderFeeDisplayEntity toDisplayEntity(List<SurchargeGroupEntity> groups) {
    return OrderFeeDisplayEntity(
      label: _resolveLabel(groups),
      baseAmount: baseAmount,
      vatRate: vatRate,
      vatAmount: vatAmount,
      totalAmount: totalAmount,
    );
  }

  String _resolveLabel(List<SurchargeGroupEntity> groups) {
    if (feeGroup != 'SURCHARGE') {
      return snapshot?.name ?? feeSubtype ?? feeGroup ?? "";
    }

    return groups.findSurchargeLabel(feeSubtype) ??
        snapshot?.name ??
        feeSubtype ??
        feeGroup ??
        "";
  }
}
