import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';

part 'get_shops_response.freezed.dart';
part 'get_shops_response.g.dart';

@freezed
abstract class GetShopsResponse with _$GetShopsResponse {
  const factory GetShopsResponse({
    @JsonKey(name: "items") List<Shop>? items,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _GetShopsResponse;

  factory GetShopsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetShopsResponseFromJson(json);
}

@freezed
abstract class Shop with _$Shop {
  const factory Shop({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopName") String? shopName,
    @JsonKey(name: "coordinates") BaseCoordinates? coordinates,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "profile") ShopProfile? profile,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}

@freezed
abstract class ShopProfile with _$ShopProfile {
  const factory ShopProfile({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "banner") String? banner,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "ownerName") String? ownerName,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "provinceCode") int? provinceCode,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "wardCode") int? wardCode,
    @JsonKey(name: "wardName") String? wardName,
  }) = _ShopProfile;

  factory ShopProfile.fromJson(Map<String, dynamic> json) =>
      _$ShopProfileFromJson(json);
}
