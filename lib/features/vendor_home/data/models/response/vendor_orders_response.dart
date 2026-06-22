import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'vendor_orders_response.freezed.dart';
part 'vendor_orders_response.g.dart';

@freezed
abstract class VendorOrdersResponse with _$VendorOrdersResponse {
  const factory VendorOrdersResponse({
    @JsonKey(name: 'items') List<VendorOrderResponse>? items,
    @JsonKey(name: 'meta') BaseMetaResponse? meta,
  }) = _VendorOrdersResponse;

  factory VendorOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorOrdersResponseFromJson(json);
}

@freezed
abstract class VendorOrderResponse with _$VendorOrderResponse {
  const factory VendorOrderResponse({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'trackingCode') String? trackingCode,
    @JsonKey(name: 'customerName') String? customerName,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'fullAddress') String? fullAddress,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'deliveryFee') int? deliveryFee,
    @JsonKey(name: 'returnFee') int? returnFee,
    @JsonKey(name: 'codAmount') int? codAmount,
    @JsonKey(name: 'collectAmount') int? collectAmount,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _VendorOrderResponse;

  factory VendorOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorOrderResponseFromJson(json);
}
