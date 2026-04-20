import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

part 'package_detail.freezed.dart';
part 'package_detail.g.dart';

@freezed
abstract class PackageDetail with _$PackageDetail {
  const factory PackageDetail({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "packageNumber") String? packageNumber,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "orderCount") int? orderCount,
    @JsonKey(name: "shipperId") String? shipperId,
    @JsonKey(name: "shipperCode") String? shipperCode,
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "duration") int? duration,
    @JsonKey(name: "totalCollectAmount") int? totalCollectAmount,
    @JsonKey(name: "totalDeliveryFee") int? totalDeliveryFee,
    @JsonKey(name: "totalCodAmount") int? totalCodAmount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "orders") @Default([]) List<OrderInfo> orders,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "shopAddress") String? shopAddress,
    @JsonKey(name: "shopPhone") String? shopPhone,
  }) = _PackageDetail;

  factory PackageDetail.fromJson(Map<String, dynamic> json) =>
      _$PackageDetailFromJson(json);
}
