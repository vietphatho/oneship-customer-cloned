import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';

part 'calculated_delivery_fee_entity.freezed.dart';

@freezed
abstract class CalculatedDeliveryFeeEntity with _$CalculatedDeliveryFeeEntity {
  const factory CalculatedDeliveryFeeEntity({
    FeeEntity? baseFee,
    FeeEntity? surchargesFee,
    @Default(0) int deliveryFee,
    @Default([]) List<dynamic> surcharges,
  }) = _CalculatedDeliveryFeeEntity;

  factory CalculatedDeliveryFeeEntity.from(CalculateDeliveryFeeResponse dto) {
    return CalculatedDeliveryFeeEntity(
      baseFee: dto.baseFee != null ? FeeEntity.from(dto.baseFee!) : null,
      surchargesFee:
          dto.surchargesFee != null ? FeeEntity.from(dto.surchargesFee!) : null,
      deliveryFee: dto.deliveryFee ?? 0,
      surcharges: dto.surcharges ?? [],
    );
  }
}

@freezed
abstract class FeeEntity with _$FeeEntity {
  const factory FeeEntity({
    @Default(0) int originalAmount,
    @Default(0) int vatRate,
    @Default(0) int vatAmount,
    @Default(0) int totalAmount,
    @Default("") String currency,
  }) = _FeeEntity;

  factory FeeEntity.from(Fee dto) {
    return FeeEntity(
      originalAmount: dto.originalAmount ?? 0,
      vatRate: dto.vatRate ?? 0,
      vatAmount: dto.vatAmount ?? 0,
      totalAmount: dto.totalAmount ?? 0,
      currency: dto.currency ?? "",
    );
  }
}
