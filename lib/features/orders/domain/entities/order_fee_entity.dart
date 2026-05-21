import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';

part 'order_fee_entity.freezed.dart';

@freezed
abstract class OrderFeeEntity with _$OrderFeeEntity {
  const OrderFeeEntity._();

  const factory OrderFeeEntity({
    String? id,
    String? shopId,
    String? orderId,
    String? feeGroup,
    dynamic feeSubtype,
    @Default(0) int baseAmount,
    @Default(0) int vatRate,
    @Default(0) int vatAmount,
    @Default(0) int totalAmount,
    dynamic snapshot,
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
      snapshot: dto.snapshot,
      createdAt: dto.createdAt,
    );
  }
}
