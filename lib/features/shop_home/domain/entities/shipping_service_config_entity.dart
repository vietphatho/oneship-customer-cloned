import 'package:oneship_customer/features/shop_home/data/models/response/shipping_service_config_response.dart';

class ShippingServiceConfigEntity {
  final String id;
  final String serviceCode;
  final String serviceLabel;
  final bool isEnabled;
  final int maxWeightKg;
  final int baseFee;
  final int sortOrder;

  ShippingServiceConfigEntity({
    required this.id,
    required this.serviceCode,
    required this.serviceLabel,
    required this.isEnabled,
    required this.maxWeightKg,
    required this.baseFee,
    required this.sortOrder,
  });

  factory ShippingServiceConfigEntity.from(ShippingServiceConfigResponse data) {
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
