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
    required int baseFee,
    required int sortOrder,
  }) = _ShippingServiceConfigEntity;

  factory ShippingServiceConfigEntity.from(ShippingService data) {
    return ShippingServiceConfigEntity(
      id: data.id ?? '',
      serviceCode: data.serviceCode ?? '',
      serviceLabel: data.serviceLabel ?? '',
      isEnabled: data.isEnabled ?? false,
      maxWeightKg: data.maxWeightKg ?? 0,
      baseFee: data.baseFee ?? 0,
      sortOrder: data.sortOrder ?? 0,
    );
  }
}
