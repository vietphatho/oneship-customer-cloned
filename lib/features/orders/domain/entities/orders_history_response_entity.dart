import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';

part 'orders_history_response_entity.freezed.dart';

@freezed
abstract class OrdersHistoryResponseEntity with _$OrdersHistoryResponseEntity {
  const factory OrdersHistoryResponseEntity({
    @Default([]) List<OrdersHistoryEntity> items,
    BaseMetaResponse? meta,
  }) = _OrdersHistoryResponseEntity;

  factory OrdersHistoryResponseEntity.fromDto(OrdersListResponse dto) {
    return OrdersHistoryResponseEntity(
      items:
          dto.data?.map((e) => OrdersHistoryEntity.fromDto(e)).toList() ?? [],
      meta: dto.meta,
    );
  }
}

@freezed
abstract class OrdersHistoryEntity with _$OrdersHistoryEntity {
  const factory OrdersHistoryEntity({
    String? id,

    String? orderNumber,
    String? trackingCode,
    String? customerName,

    String? phone,
    String? email,

    String? fullAddress,
    String? fullAddressOld,

    int? wardCode,
    String? wardName,

    int? provinceCode,
    String? provinceName,

    @Default('') String status,

    String? paymentStatus,
    String? paymentMethod,
    PackageSize? packageSize,
    String? payer,

    @Default(0) int codAmount,
    @Default(0) int collectAmount,

    DateTime? createdAt,

    String? shopId,
    String? serviceCode,
    String? externalOrderId,

    DateTime? sequenceDate,

    @Default(0) int dailySequence,
    @Default(0) int totalProductAmount,
    @Default(0) int totalDiscountAmount,
    @Default(0) int totalFeeAmount,
    @Default(0) int totalDeliveryFee,

    String? createdByUserId,

    DateTime? statusUpdateTime,

    BaseCoordinates? coordinates,

    String? distance,

    @Default(false) bool isReturnOrder,

    @Default([]) List<String> userCodes,

    dynamic customerId,

    DateTime? updatedAt,

    @Default([]) List<OrderFeeEntity> orderFees,
  }) = _OrdersHistoryEntity;

  factory OrdersHistoryEntity.fromDto(OrderInfo dto) {
    return OrdersHistoryEntity(
      id: dto.id,
      orderNumber: dto.orderNumber,
      trackingCode: dto.trackingCode,
      customerName: dto.customerName,
      phone: dto.phone,
      email: dto.email,
      fullAddress: dto.fullAddress,
      fullAddressOld: dto.fullAddressOld,
      wardCode: dto.wardCode,
      wardName: dto.wardName,
      provinceCode: dto.provinceCode,
      provinceName: dto.provinceName,
      status: dto.status ?? '',
      paymentStatus: dto.paymentStatus ?? '',
      paymentMethod: dto.paymentMethod ?? '',
      packageSize: findPackageSize(dto.packageSize),
      payer: dto.payer ?? '',
      codAmount: dto.codAmount ?? 0,
      collectAmount: dto.collectAmount ?? 0,
      createdAt: dto.createdAt,
      shopId: dto.shopId,
      serviceCode: dto.serviceCode,
      externalOrderId: dto.externalOrderId,
      // sequenceDate: dto.sequenceDate,
      dailySequence: dto.dailySequence ?? 0,
      totalProductAmount: dto.totalProductAmount ?? 0,
      totalDiscountAmount: dto.totalDiscountAmount ?? 0,
      totalFeeAmount: dto.totalFeeAmount ?? 0,
      totalDeliveryFee: dto.totalDeliveryFee ?? 0,
      createdByUserId: dto.createdByUserId,
      statusUpdateTime: dto.statusUpdateTime,
      coordinates: dto.coordinates,
      distance: dto.distance,
      isReturnOrder: dto.isReturnOrder ?? false,
      userCodes: dto.userCodes ?? [],
      // customerId: dto.customerId,
      updatedAt: dto.updatedAt,
      orderFees:
          dto.orderFees?.map((e) => OrderFeeEntity.from(e)).toList() ?? [],
    );
  }
}
