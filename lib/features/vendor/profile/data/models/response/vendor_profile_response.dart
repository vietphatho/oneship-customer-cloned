import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_profile_response.freezed.dart';
part 'vendor_profile_response.g.dart';

@freezed
abstract class VendorProfileResponse with _$VendorProfileResponse {
  const factory VendorProfileResponse({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'shopId') String? shopId,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'vendorName') String? vendorName,
    @JsonKey(name: 'vendorCode') String? vendorCode,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'fullAddress') String? fullAddress,
    @JsonKey(name: 'wardCode') int? wardCode,
    @JsonKey(name: 'provinceCode') int? provinceCode,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @JsonKey(name: 'deletedAt') DateTime? deletedAt,
  }) = _VendorProfileResponse;

  factory VendorProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorProfileResponseFromJson(json);
}
