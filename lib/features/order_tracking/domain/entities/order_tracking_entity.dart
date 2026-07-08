import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/features/order_tracking/data/models/response/order_tracking_response.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';

part 'order_tracking_entity.freezed.dart';

@freezed
abstract class OrderTrackingEntity with _$OrderTrackingEntity {
  const factory OrderTrackingEntity({
    @Default("") String id,
    @Default("") String orderId,
    @Default("") String orderNumber,
    @Default("") String trackingCode,
    @Default("") String fullAddress,
    @Default("") String status,
    @Default(0.0) double codAmount,
    @Default(0.0) double totalDeliveryFee,
    String? serviceCode,
    @Default(true) bool isIntraCity,
    @Default(0) int weight,
    DateTime? createdAt,
    ShipperEntity? shipper,
    @Default([]) List<DeliveryHistoryEntity> deliveryHistory,
    ShopInfoEntity? shopInfo,
    CustomerEntity? customer,
    int? collectAmount,
    BaseCoordinates? coordinates,
  }) = _OrderTrackingEntity;

  factory OrderTrackingEntity.from(OrderTrackingResponse dto) {
    return OrderTrackingEntity(
      id: dto.id ?? "",
      orderId: dto.orderId ?? "",
      orderNumber: dto.orderNumber ?? "",
      trackingCode: dto.trackingCode ?? "",
      fullAddress: dto.fullAddress ?? "",
      status: dto.status ?? "",
      codAmount: (dto.codAmount ?? 0).toDouble(),
      totalDeliveryFee: (dto.totalDeliveryFee ?? 0).toDouble(),
      serviceCode: dto.serviceCode,
      isIntraCity: dto.isIntraCity ?? true,
      weight: dto.weight ?? 0,
      createdAt: dto.createdAt,
      shipper: dto.shipper != null ? ShipperEntity.from(dto.shipper!) : null,
      deliveryHistory:
          dto.deliveryHistory
              ?.map((e) => DeliveryHistoryEntity.from(e))
              .toList() ??
          [],
      shopInfo: dto.shopInfo != null
          ? ShopInfoEntity.from(dto.shopInfo!)
          : null,
      customer: dto.customer != null
          ? CustomerEntity.from(dto.customer!)
          : null,
      collectAmount: dto.collectAmount,
      coordinates: dto.coordinates,
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
    String? avatarUrl,
    BaseCoordinates? coordinates,
  }) = _ShipperEntity;

  factory ShipperEntity.from(Shipper dto) {
    return ShipperEntity(
      name: dto.name,
      shipperCodes: dto.shipperCodes,
      phone: dto.phone,
      avatarUrl: dto.avatarUrl,
      coordinates: dto.coordinates,
    );
  }
}

@freezed
abstract class DeliveryHistoryEntity with _$DeliveryHistoryEntity {
  const factory DeliveryHistoryEntity({
    @Default(OrderStatus.allProcessing) OrderStatus status,
    String? rawStatus,
    @Default([]) List<String> confirmationImages,
    DateTime? shippingAt,
    DateTime? arrivedAtDelivery,
    DateTime? deliveredAt,
    DateTime? addedToPackageAt,
    DateTime? scannedAt,
    DateTime? pickupConfirmedAt,
    DateTime? quantityConfirmedAt,
    @Default([]) List<String> pickupImages,
    @Default(false) bool isVerified,
  }) = _DeliveryHistoryEntity;

  factory DeliveryHistoryEntity.from(DeliveryHistory dto) {
    return DeliveryHistoryEntity(
      status: _getStatus(dto.status),
      rawStatus: dto.status,
      confirmationImages: dto.confirmationImages ?? [],
      arrivedAtDelivery: dto.arrivedAtDelivery,
      deliveredAt: dto.deliveredAt,
      addedToPackageAt: dto.addedToPackageAt,
      scannedAt: dto.scannedAt,
      pickupConfirmedAt: dto.pickupConfirmedAt,
      quantityConfirmedAt: dto.quantityConfirmedAt,
      shippingAt: dto.shippingAt,
      pickupImages: dto.pickupImages ?? [],
      isVerified: dto.isVerified ?? false,
    );
  }

  static OrderStatus _getStatus(String? rawValue) {
    return OrderStatus.values.firstWhereOrNull((e) => e.value == rawValue) ??
        OrderStatus.allProcessing;
  }
}

@freezed
abstract class ShopInfoEntity with _$ShopInfoEntity {
  const factory ShopInfoEntity({
    String? shopId,
    String? shopName,
    String? shopPhone,
    BaseCoordinates? coordinate,
  }) = _ShopInfoEntity;

  factory ShopInfoEntity.from(ShopInfo dto) => ShopInfoEntity(
    shopId: dto.shopId,
    shopName: dto.shopName,
    shopPhone: dto.shopPhone,
    coordinate: dto.coordinate,
  );
}

@freezed
abstract class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    String? customerName,
    String? customerPhone,
    String? customerFullAddress,
  }) = _CustomerEntity;

  factory CustomerEntity.from(Customer dto) => CustomerEntity(
    customerName: dto.customerName,
    customerPhone: dto.customerPhone,
    customerFullAddress: dto.customerFullAddress,
  );
}
