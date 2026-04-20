import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';

part 'calculated_delivery_fee_entity.freezed.dart';

@freezed
abstract class CalculatedDeliveryFeeEntity with _$CalculatedDeliveryFeeEntity {
  const factory CalculatedDeliveryFeeEntity({
    @Default(0) int baseFee,
    @Default(0) int totalSurchargeFee,
    @Default(0) int subtotal,
    @Default(0) int deliveryFee,
    @Default(0) int grossFee,
    @Default(0) int vat,
    @Default(0) int vatRate,
    @Default([]) List<dynamic> surcharges,
  }) = _CalculatedDeliveryFeeEntity;

  factory CalculatedDeliveryFeeEntity.from(CalculateDeliveryFeeResponse dto) {
    return CalculatedDeliveryFeeEntity(
      baseFee: dto.baseFee,
      totalSurchargeFee: dto.totalSurchargeFee,
      subtotal: dto.subtotal,
      deliveryFee: dto.deliveryFee,
      grossFee: dto.grossFee,
      vat: dto.vat,
      vatRate: dto.vatRate,
      surcharges: dto.surcharges,
    );
  }
}
