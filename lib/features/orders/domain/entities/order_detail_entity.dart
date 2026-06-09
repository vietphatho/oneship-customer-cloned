import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/order_detail_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/shipper_info_entity.dart';

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
    PackageSize? packageSize,
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
    ShipperInfoEntity? shipper,
    DateTime? pickupDate,
    String? pickupTimeSlot,
    String? deliveryTimeSlot,
    double? weight,
    int? length,
    int? width,
    int? height,
    @Default(false) bool isFragile,
    @Default(false) bool isLiquid,
    @Default(false) bool hasBattery,
    String? note,
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
      packageSize: findPackageSize(dto.packageSize),
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
      pickupDate: dto.detail?.pickupDate,
      pickupTimeSlot: dto.detail?.pickupTimeSlot,
      deliveryTimeSlot: dto.detail?.deliveryTimeSlot?.toString(),
      weight: dto.detail != null
          ? double.tryParse(dto.detail!.weight ?? "")
          : null,
      length: dto.detail != null
          ? int.tryParse(dto.detail!.length ?? "0")
          : null,
      width: dto.detail != null ? int.tryParse(dto.detail!.width ?? "0") : null,
      height: dto.detail != null
          ? int.tryParse(dto.detail!.height ?? "0")
          : null,
      isFragile: dto.detail?.isFragile ?? false,
      isLiquid: dto.detail?.isLiquid ?? false,
      hasBattery: dto.detail?.hasBattery ?? false,
      note: dto.detail?.note?.toString(),
      items:
          dto.items
              ?.map((dto) => OrderDetailProductEntity.from(dto))
              .toList() ??
          [],
      shop: dto.shop != null ? OrderDetailShopEntity.fromDto(dto.shop!) : null,
      orderFees:
          dto.orderFees?.map((e) => OrderFeeEntity.from(e)).toList() ?? [],
      totalProductAmount: dto.totalProductAmount ?? 0,
      totalDeliveryFee: dto.totalDeliveryFee ?? 0,
    );
  }

  factory OrderDetailEntity.fromHistoryModel(OrdersHistoryEntity model) {
    return OrderDetailEntity(
      id: model.id,
      orderNumber: model.orderNumber,
      externalOrderId: model.externalOrderId,
      serviceCode: model.serviceCode,
      trackingCode: model.trackingCode,
      sequenceDate: model.sequenceDate,
      dailySequence: model.dailySequence,
      totalDiscountAmount: model.totalDiscountAmount,
      totalFeeAmount: model.totalFeeAmount,
      codAmount: model.codAmount,
      collectAmount: model.collectAmount,
      status: model.status,
      statusUpdateTime: model.statusUpdateTime,
      fullAddress: model.fullAddress,
      fullAddressOld: model.fullAddressOld,
      wardCode: model.wardCode,
      wardName: model.wardName,
      provinceCode: model.provinceCode,
      provinceName: model.provinceName,
      phone: model.phone,
      customerName: model.customerName,
      email: model.email,
      packageSize: model.packageSize,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      paymentStatus: model.paymentStatus,
      paymentMethod: model.paymentMethod,
      coordinates: model.coordinates,
      distance: model.distance,
      shopId: model.shopId,
      payer: model.payer,
      isReturnOrder: model.isReturnOrder,
      createdByUserId: model.createdByUserId,
      shipperCodes: model.userCodes,
      orderFees: model.orderFees,
      totalProductAmount: model.totalProductAmount,
      totalDeliveryFee: model.totalDeliveryFee,
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

// @freezed
// abstract class DetailEntity with _$DetailEntity {
//   const DetailEntity._();

//   const factory DetailEntity({
//     String? id,
//     String? orderId,
//     DateTime? pickupDate,
//     String? pickupTimeSlot,
//     String? deliveryTimeSlot,
//     double? weight,
//     double? length,
//     double? width,
//     double? height,
//     @Default(false) bool isFragile,
//     @Default(false) bool isLiquid,
//     @Default(false) bool hasBattery,
//     String? note,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) = _DetailEntity;

//   factory DetailEntity.from(Detail dto) {
//     return DetailEntity(
//       id: dto.id,
//       orderId: dto.orderId,
//       pickupDate: dto.pickupDate,
//       pickupTimeSlot: dto.pickupTimeSlot,
//       deliveryTimeSlot: dto.deliveryTimeSlot?.toString(),
//       weight: double.tryParse(dto.weight ?? ""),
//       length: double.tryParse(dto.length ?? ""),
//       width: double.tryParse(dto.width ?? ""),
//       height: double.tryParse(dto.height ?? ""),
//       isFragile: dto.isFragile ?? false,
//       isLiquid: dto.isLiquid ?? false,
//       hasBattery: dto.hasBattery ?? false,
//       note: dto.note?.toString(),
//       createdAt: dto.createdAt,
//       updatedAt: dto.updatedAt,
//     );
//   }
// }

@freezed
abstract class OrderDetailShopEntity with _$OrderDetailShopEntity {
  const factory OrderDetailShopEntity({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopName") @Default("") String shopName,
    @JsonKey(name: "phone") @Default("") String phone,
    @JsonKey(name: "fullAddress") @Default("") String fullAddress,
    @JsonKey(name: "shopCode") String? shopCode,
    @JsonKey(name: "shopType") String? shopType,
  }) = _OrderDetailShopEntity;

  factory OrderDetailShopEntity.fromDto(Shop dto) => OrderDetailShopEntity(
    id: dto.id,
    shopName: dto.shopName ?? "",
    shopCode: dto.shopCode,
    phone: dto.phone ?? "",
    fullAddress: dto.fullAddress ?? "",
    shopType: dto.shopType,
  );
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
