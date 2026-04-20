import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'packages_list_response.freezed.dart';
part 'packages_list_response.g.dart';

@freezed
abstract class PackagesListResponse with _$PackagesListResponse {
  const factory PackagesListResponse({
    @JsonKey(name: "items") List<Package>? data,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _PackagesListResponse;

  factory PackagesListResponse.fromJson(Map<String, dynamic> json) =>
      _$PackagesListResponseFromJson(json);
}

@freezed
abstract class Package with _$Package {
  const factory Package({
    @JsonKey(name: "id") @Default("") String id,
    @JsonKey(name: "packageNumber") String? packageNumber,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "shipperId") String? shipperId,
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "duration") int? duration,
    @JsonKey(name: "totalCollectAmount") int? totalCollectAmount,
    @JsonKey(name: "totalDeliveryFee") int? totalDeliveryFee,
    @JsonKey(name: "totalShippingFee") int? totalShippingFee,
    @JsonKey(name: "totalCodAmount") int? totalCodAmount,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "pickupImages") dynamic pickupImages,
    @JsonKey(name: "pickupConfirmedAt") dynamic pickupConfirmedAt,
    @JsonKey(name: "quantityConfirmedAt") dynamic quantityConfirmedAt,
    @JsonKey(name: "totalOrders") int? totalOrders,
    @JsonKey(name: "mergedToPackageId") String? mergedToPackageId,
    @JsonKey(name: "shipper") Shipper? shipper,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
}

@freezed
abstract class Shipper with _$Shipper {
  const factory Shipper({
    @JsonKey(name: "id") @Default("") String id,
    @JsonKey(name: "userLogin") String? userLogin,
    @JsonKey(name: "displayName") String? displayName,
    @JsonKey(name: "userEmail") dynamic userEmail,
    @JsonKey(name: "userStatus") String? userStatus,
    @JsonKey(name: "userPhone") String? userPhone,
    @JsonKey(name: "avatarUrl") String? avatarUrl,
    @JsonKey(name: "userCode") String? userCode,
    @JsonKey(name: "referrerCode") dynamic referrerCode,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "lastCoordinatesUpdated") DateTime? lastCoordinatesUpdated,
    @JsonKey(name: "userRegistered") DateTime? userRegistered,
    @JsonKey(name: "failedLoginAttempts") int? failedLoginAttempts,
    @JsonKey(name: "lockoutUntil") dynamic lockoutUntil,
    @JsonKey(name: "shipperDocsCompleted") bool? shipperDocsCompleted,
    @JsonKey(name: "lastLoginAt") DateTime? lastLoginAt,
    @JsonKey(name: "isVerified") bool? isVerified,
    @JsonKey(name: "coordinates") BaseCoordinates? coordinates,
    @JsonKey(name: "roleId") int? roleId,
  }) = _Shipper;

  factory Shipper.fromJson(Map<String, dynamic> json) =>
      _$ShipperFromJson(json);
}
