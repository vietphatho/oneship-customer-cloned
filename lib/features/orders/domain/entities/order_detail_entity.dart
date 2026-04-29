import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';

part 'order_detail_entity.freezed.dart';

@freezed
abstract class OrderDetailEntity with _$OrderDetailEntity {
  const OrderDetailEntity._();

  const factory OrderDetailEntity({
    String? id,
    String? orderNumber,
    String? externalOrderId,
    String? serviceCode,
    String? trackingCode,
    DateTime? sequenceDate,
    int? dailySequence,
    @Default(0) int totalDiscountAmount,
    @Default(0) int totalFeeAmount,
    @Default(0) int codAmount,
    @Default(0) int collectAmount,
    String? status,
    DateTime? statusUpdateTime,
    String? fullAddress,
    String? fullAddressOld,
    int? wardCode,
    String? wardName,
    int? provinceCode,
    String? provinceName,
    String? phone,
    String? customerName,
    String? email,
    String? packageType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentStatus,
    String? paymentMethod,
    BaseCoordinates? coordinates,
    String? distance,
    String? shopId,
    String? payer,
    @Default(false) bool isReturnOrder,
    String? createdByUserId,
    @Default([]) List<String> shipperCodes,
    DetailEntity? detail,
    @Default([]) List<OrderDetailProductEntity> items,
    OrderDetailShopEntity? shop,
    @Default([]) List<OrderFeeEntity> orderFees,
    @Default(0) int totalProductAmount,
    @Default(0) int totalDeliveryFee,
  }) = _OrderDetailEntity;

  factory OrderDetailEntity.from(OrderDetailResponse dto) {
    return OrderDetailEntity(
      id: dto.id,
      orderNumber: dto.orderNumber,
      externalOrderId: dto.externalOrderId,
      serviceCode: dto.serviceCode,
      trackingCode: dto.trackingCode,
      sequenceDate: dto.sequenceDate,
      dailySequence: dto.dailySequence,
      totalDiscountAmount: dto.totalDiscountAmount ?? 0,
      totalFeeAmount: dto.totalFeeAmount ?? 0,
      codAmount: dto.codAmount ?? 0,
      collectAmount: dto.collectAmount ?? 0,
      status: dto.status,
      statusUpdateTime: dto.statusUpdateTime,
      fullAddress: dto.fullAddress,
      fullAddressOld: dto.fullAddressOld,
      wardCode: dto.wardCode,
      wardName: dto.wardName,
      provinceCode: dto.provinceCode,
      provinceName: dto.provinceName,
      phone: dto.phone,
      customerName: dto.customerName,
      email: dto.email,
      packageType: dto.packageType,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      paymentStatus: dto.paymentStatus,
      paymentMethod: dto.paymentMethod,
      coordinates: dto.coordinates,
      distance: dto.distance,
      shopId: dto.shopId,
      payer: dto.payer,
      isReturnOrder: dto.isReturnOrder ?? false,
      createdByUserId: dto.createdByUserId,
      shipperCodes: dto.shipperCodes?.map((e) => e.toString()).toList() ?? [],
      detail: dto.detail != null ? DetailEntity.from(dto.detail!) : null,
      items:
          dto.items
              ?.map((dto) => OrderDetailProductEntity.from(dto))
              .toList() ??
          [],
      shop: dto.shop != null ? OrderDetailShopEntity.from(dto.shop!) : null,
      orderFees:
          dto.orderFees?.map((e) => OrderFeeEntity.from(e)).toList() ?? [],
      totalProductAmount: dto.totalProductAmount ?? 0,
      totalDeliveryFee: dto.totalDeliveryFee ?? 0,
    );
  }
}

extension OrderDetailEntityExt on OrderDetailEntity {
  int get totalProductQty => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalProductPrice => items.fold(
    0,
    (sum, item) => sum + (item.unitPrice * item.quantity) - item.discountAmount,
  );
}

@freezed
abstract class DetailEntity with _$DetailEntity {
  const DetailEntity._();

  const factory DetailEntity({
    String? id,
    String? orderId,
    DateTime? pickupDate,
    String? pickupTimeSlot,
    String? deliveryTimeSlot,
    double? weight,
    double? length,
    double? width,
    double? height,
    @Default(false) bool isFragile,
    @Default(false) bool isLiquid,
    @Default(false) bool hasBattery,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DetailEntity;

  factory DetailEntity.from(Detail dto) {
    return DetailEntity(
      id: dto.id,
      orderId: dto.orderId,
      pickupDate: dto.pickupDate,
      pickupTimeSlot: dto.pickupTimeSlot,
      deliveryTimeSlot: dto.deliveryTimeSlot?.toString(),
      weight: double.tryParse(dto.weight ?? ""),
      length: double.tryParse(dto.length ?? ""),
      width: double.tryParse(dto.width ?? ""),
      height: double.tryParse(dto.height ?? ""),
      isFragile: dto.isFragile ?? false,
      isLiquid: dto.isLiquid ?? false,
      hasBattery: dto.hasBattery ?? false,
      note: dto.note?.toString(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}

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
    dynamic snapshot,
    DateTime? createdAt,
  }) = _OrderFeeEntity;

  factory OrderFeeEntity.from(OrderFee dto) {
    return OrderFeeEntity(
      id: dto.id,
      shopId: dto.shopId,
      orderId: dto.orderId,
      feeGroup: dto.feeGroup,
      feeSubtype: dto.feeSubtype?.toString(),
      baseAmount: dto.baseAmount ?? 0,
      vatRate: dto.vatRate ?? 0,
      vatAmount: dto.vatAmount ?? 0,
      totalAmount: dto.totalAmount ?? 0,
      snapshot: dto.snapshot,
      createdAt: dto.createdAt,
    );
  }
}

@freezed
abstract class OrderDetailShopEntity with _$OrderDetailShopEntity {
  const OrderDetailShopEntity._();

  const factory OrderDetailShopEntity({
    String? id,
    String? shopName,
    ProfileEntity? profile,
  }) = _OrderDetailShopEntity;

  factory OrderDetailShopEntity.from(Shop dto) {
    return OrderDetailShopEntity(
      id: dto.id,
      shopName: dto.shopName,
      profile: dto.profile != null ? ProfileEntity.from(dto.profile!) : null,
    );
  }
}

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const ProfileEntity._();

  const factory ProfileEntity({String? phone, String? fullAddress}) =
      _ProfileEntity;

  factory ProfileEntity.from(Profile dto) {
    return ProfileEntity(phone: dto.phone, fullAddress: dto.fullAddress);
  }
}

@freezed
abstract class OrderDetailProductEntity with _$OrderDetailProductEntity {
  const OrderDetailProductEntity._();

  const factory OrderDetailProductEntity({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    String? productSku,
    String? variantId,
    String? variantName,
    String? variantAttributes,
    @Default(0) int quantity,
    @Default(0) int unitPrice,
    @Default(0) int discountAmount,
    DateTime? createdAt,
  }) = _OrderDetailProductEntity;

  factory OrderDetailProductEntity.from(OrderDetailProductResponse dto) {
    return OrderDetailProductEntity(
      id: dto.id,
      orderId: dto.orderId,
      productId: dto.productId,
      productName: dto.productName,
      productSku: dto.productSku,
      variantId: dto.variantId?.toString(),
      variantName: dto.variantName?.toString(),
      variantAttributes: dto.variantAttributes?.toString(),
      quantity: dto.quantity ?? 0,
      unitPrice: dto.unitPrice ?? 0,
      discountAmount: dto.discountAmount ?? 0,
      createdAt: dto.createdAt,
    );
  }

  OrderDetailProductResponse toDto() {
    return OrderDetailProductResponse(
      id: id,
      orderId: orderId,
      productId: productId,
      productName: productName,
      productSku: productSku,
      variantId: variantId,
      variantName: variantName,
      variantAttributes: variantAttributes,
      quantity: quantity,
      unitPrice: unitPrice,
      discountAmount: discountAmount,
      createdAt: createdAt,
    );
  }
}
