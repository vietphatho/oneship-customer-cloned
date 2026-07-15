import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/vendor/finance/data/models/response/finance_response.dart';

part 'finance_entity.freezed.dart';

@freezed
abstract class VendorFinanceEntity with _$VendorFinanceEntity {
  factory VendorFinanceEntity({
    String? shopId,
    String? startDate,
    String? endDate,
    int? totalIn,
    int? codCollected,
    int? totalOut,
    int? deliveryFee,
    int? deliveryFeeVat,
    int? surchargeFee,
    int? surchargeVat,
    int? returnForwardFee,
    int? returnForwardFeeVat,
    int? returnDeliveryFee,
    int? returnDeliveryFeeVat,
    int? returnSurchargeFee,
    int? returnSurchargeVat,
    int? discountAmount,
    int? rebateAmount,
    int? adjustmentAmount,
    int? netAmount,
    int? orderCount,
    int? returnedOrderCount,
    List<DailyBreakdownEntity>? dailyBreakdown,
  }) = _VendorFinanceEntity;

  factory VendorFinanceEntity.from(VendorFinanceResponse dto) {
    return VendorFinanceEntity(
      shopId: dto.shopId,
      startDate: dto.startDate,
      endDate: dto.endDate,
      totalIn: dto.totalIn,
      codCollected: dto.codCollected,
      totalOut: dto.totalOut,
      deliveryFee: dto.deliveryFee,
      deliveryFeeVat: dto.deliveryFeeVat,
      surchargeFee: dto.surchargeFee,
      surchargeVat: dto.surchargeVat,
      returnForwardFee: dto.returnForwardFee,
      returnForwardFeeVat: dto.returnForwardFeeVat,
      returnDeliveryFee: dto.returnDeliveryFee,
      returnDeliveryFeeVat: dto.returnDeliveryFeeVat,
      returnSurchargeFee: dto.returnSurchargeFee,
      returnSurchargeVat: dto.returnSurchargeVat,
      discountAmount: dto.discountAmount,
      rebateAmount: dto.rebateAmount,
      adjustmentAmount: dto.adjustmentAmount,
      netAmount: dto.netAmount,
      orderCount: dto.orderCount,
      returnedOrderCount: dto.returnedOrderCount,
      dailyBreakdown: dto.dailyBreakdown
          ?.map((e) => DailyBreakdownEntity.from(e))
          .toList(),
    );
  }
}

@freezed
abstract class DailyBreakdownEntity with _$DailyBreakdownEntity {
  factory DailyBreakdownEntity({
    String? id,
    String? shopId,
    String? date,
    int? totalIn,
    int? codCollected,
    int? totalOut,
    int? deliveryFee,
    int? deliveryFeeVat,
    int? surchargeFee,
    int? surchargeVat,
    int? returnForwardFee,
    int? returnForwardFeeVat,
    int? returnDeliveryFee,
    int? returnDeliveryFeeVat,
    int? returnSurchargeFee,
    int? returnSurchargeVat,
    int? discountAmount,
    int? rebateAmount,
    int? adjustmentAmount,
    int? netAmount,
    int? orderCount,
    int? returnedOrderCount,
    VatBreakdownEntity? vatBreakdownEntity,
    String? lastAggregatedAt,
    String? createdAt,
    String? updatedAt,
  }) = _DailyBreakdownEntity;

  factory DailyBreakdownEntity.from(DailyBreakdown dto) {
    return DailyBreakdownEntity(
      id: dto.id,
      shopId: dto.shopId,
      date: dto.date,
      totalIn: dto.totalIn,
      codCollected: dto.codCollected,
      totalOut: dto.totalOut,
      deliveryFee: dto.deliveryFee,
      deliveryFeeVat: dto.deliveryFeeVat,
      surchargeFee: dto.surchargeFee,
      surchargeVat: dto.surchargeVat,
      returnForwardFee: dto.returnForwardFee,
      returnForwardFeeVat: dto.returnForwardFeeVat,
      returnDeliveryFee: dto.returnDeliveryFee,
      returnDeliveryFeeVat: dto.returnDeliveryFeeVat,
      returnSurchargeFee: dto.returnSurchargeFee,
      returnSurchargeVat: dto.returnSurchargeVat,
      discountAmount: dto.discountAmount,
      rebateAmount: dto.rebateAmount,
      adjustmentAmount: dto.adjustmentAmount,
      netAmount: dto.netAmount,
      orderCount: dto.orderCount,
      returnedOrderCount: dto.returnedOrderCount,
      vatBreakdownEntity: dto.vatBreakdown != null
          ? VatBreakdownEntity.from(dto.vatBreakdown!)
          : null,
      lastAggregatedAt: dto.lastAggregatedAt,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}

@freezed
abstract class VatBreakdownEntity with _$VatBreakdownEntity {
  factory VatBreakdownEntity({dynamic byRate}) = _VatBreakdownEntity;

  factory VatBreakdownEntity.from(VatBreakdown dto) {
    return VatBreakdownEntity(byRate: dto.byRate);
  }
}

extension VendorFinanceEntityX on VendorFinanceEntity {
  int get totalReturnedFee =>
      (returnForwardFee ?? 0) +
      (returnForwardFeeVat ?? 0) +
      (returnDeliveryFee ?? 0) +
      (returnForwardFeeVat ?? 0) +
      (returnSurchargeFee ?? 0) +
      (returnSurchargeVat ?? 0);
}

extension DailyBreakdownEntityX on DailyBreakdownEntity {
  int get totalReturnedFee =>
      (returnForwardFee ?? 0) +
      (returnForwardFeeVat ?? 0) +
      (returnDeliveryFee ?? 0) +
      (returnForwardFeeVat ?? 0) +
      (returnSurchargeFee ?? 0) +
      (returnSurchargeVat ?? 0);
}
