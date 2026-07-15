import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_response.freezed.dart';
part 'finance_response.g.dart';

@freezed
abstract class VendorFinanceResponse with _$VendorFinanceResponse {
  factory VendorFinanceResponse({
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "startDate") String? startDate,
    @JsonKey(name: "endDate") String? endDate,
    @JsonKey(name: "totalIn") int? totalIn,
    @JsonKey(name: "codCollected") int? codCollected,
    @JsonKey(name: "totalOut") int? totalOut,
    @JsonKey(name: "deliveryFee") int? deliveryFee,
    @JsonKey(name: "deliveryFeeVat") int? deliveryFeeVat,
    @JsonKey(name: "surchargeFee") int? surchargeFee,
    @JsonKey(name: "surchargeVat") int? surchargeVat,
    @JsonKey(name: "returnForwardFee") int? returnForwardFee,
    @JsonKey(name: "returnForwardFeeVat") int? returnForwardFeeVat,
    @JsonKey(name: "returnDeliveryFee") int? returnDeliveryFee,
    @JsonKey(name: "returnDeliveryFeeVat") int? returnDeliveryFeeVat,
    @JsonKey(name: "returnSurchargeFee") int? returnSurchargeFee,
    @JsonKey(name: "returnSurchargeVat") int? returnSurchargeVat,
    @JsonKey(name: "discountAmount") int? discountAmount,
    @JsonKey(name: "rebateAmount") int? rebateAmount,
    @JsonKey(name: "adjustmentAmount") int? adjustmentAmount,
    @JsonKey(name: "netAmount") int? netAmount,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "returnedOrderCount") int? returnedOrderCount,
    @JsonKey(name: "dailyBreakdown") List<DailyBreakdown>? dailyBreakdown,
  }) = _VendorFinanceResponse;

  factory VendorFinanceResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorFinanceResponseFromJson(json);
}

@freezed
abstract class DailyBreakdown with _$DailyBreakdown {
  factory DailyBreakdown({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "date") String? date,
    @JsonKey(name: "totalIn") int? totalIn,
    @JsonKey(name: "codCollected") int? codCollected,
    @JsonKey(name: "totalOut") int? totalOut,
    @JsonKey(name: "deliveryFee") int? deliveryFee,
    @JsonKey(name: "deliveryFeeVat") int? deliveryFeeVat,
    @JsonKey(name: "surchargeFee") int? surchargeFee,
    @JsonKey(name: "surchargeVat") int? surchargeVat,
    @JsonKey(name: "returnForwardFee") int? returnForwardFee,
    @JsonKey(name: "returnForwardFeeVat") int? returnForwardFeeVat,
    @JsonKey(name: "returnDeliveryFee") int? returnDeliveryFee,
    @JsonKey(name: "returnDeliveryFeeVat") int? returnDeliveryFeeVat,
    @JsonKey(name: "returnSurchargeFee") int? returnSurchargeFee,
    @JsonKey(name: "returnSurchargeVat") int? returnSurchargeVat,
    @JsonKey(name: "discountAmount") int? discountAmount,
    @JsonKey(name: "rebateAmount") int? rebateAmount,
    @JsonKey(name: "adjustmentAmount") int? adjustmentAmount,
    @JsonKey(name: "netAmount") int? netAmount,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "returnedOrderCount") int? returnedOrderCount,
    @JsonKey(name: "vatBreakdown") VatBreakdown? vatBreakdown,
    @JsonKey(name: "lastAggregatedAt") String? lastAggregatedAt,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _DailyBreakdown;

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$DailyBreakdownFromJson(json);
}

@freezed
abstract class VatBreakdown with _$VatBreakdown {
  factory VatBreakdown({@JsonKey(name: "byRate") dynamic byRate}) =
      _VatBreakdown;

  factory VatBreakdown.fromJson(Map<String, dynamic> json) =>
      _$VatBreakdownFromJson(json);
}
