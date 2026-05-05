import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/order_tracking/data/models/response/order_tracking_response.dart';

part 'order_tracking_entity.freezed.dart';

@freezed
abstract class OrderTrackingEntity with _$OrderTrackingEntity {
  const factory OrderTrackingEntity({
    @Default("") String orderNumber,
    @Default("") String trackingCode,
    String? serviceCode,
    @Default(0) int weight,
    ShipperEntity? shipper,
    @Default([]) List<DeliveryHistoryEntity> deliveryHistory,
  }) = _OrderTrackingEntity;

  factory OrderTrackingEntity.from(OrderTrackingResponse dto) {
    return OrderTrackingEntity(
      orderNumber: dto.orderNumber ?? "",
      trackingCode: dto.trackingCode ?? "",
      serviceCode: dto.serviceCode,
      weight: dto.weight ?? 0,
      shipper: dto.shipper != null ? ShipperEntity.from(dto.shipper!) : null,
      deliveryHistory:
          dto.deliveryHistory
              ?.map((e) => DeliveryHistoryEntity.from(e))
              .toList() ??
          [],
    );
  }
}

extension OrderTrackingEntityX on OrderTrackingEntity {
  bool get isEmpty => orderNumber.isEmpty;
}

@freezed
abstract class ShipperEntity with _$ShipperEntity {
  const factory ShipperEntity({
    String? name,
    String? shipperCodes,
    String? phone,
  }) = _ShipperEntity;

  factory ShipperEntity.from(Shipper dto) {
    return ShipperEntity(
      name: dto.name,
      shipperCodes: dto.shipperCodes,
      phone: dto.phone,
    );
  }
}

@freezed
abstract class DeliveryHistoryEntity with _$DeliveryHistoryEntity {
  const factory DeliveryHistoryEntity({
    String? status,
    List<String>? confirmationImages,
    DateTime? arrivedAtDelivery,
    DateTime? deliveredAt,
    DateTime? addedToPackageAt,
    DateTime? scannedAt,
    DateTime? pickupConfirmedAt,
    DateTime? quantityConfirmedAt,
    List<String>? pickupImages,
  }) = _DeliveryHistoryEntity;

  factory DeliveryHistoryEntity.from(DeliveryHistory dto) {
    return DeliveryHistoryEntity(
      status: dto.status,
      confirmationImages: dto.confirmationImages,
      arrivedAtDelivery: dto.arrivedAtDelivery,
      deliveredAt: dto.deliveredAt,
      addedToPackageAt: dto.addedToPackageAt,
      scannedAt: dto.scannedAt,
      pickupConfirmedAt: dto.pickupConfirmedAt,
      quantityConfirmedAt: dto.quantityConfirmedAt,
      pickupImages: dto.pickupImages,
    );
  }
}
