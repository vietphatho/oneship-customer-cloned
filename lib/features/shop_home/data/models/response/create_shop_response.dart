import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shop_response.freezed.dart';
part 'create_shop_response.g.dart';

@freezed
abstract class CreateShopResponse with _$CreateShopResponse {
  const factory CreateShopResponse({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'shopName') String? shopName,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'profile') CreateShopProfileResponse? profile,
  }) = _CreateShopResponse;

  factory CreateShopResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateShopResponseFromJson(json);
}

@freezed
abstract class CreateShopProfileResponse with _$CreateShopProfileResponse {
  const factory CreateShopProfileResponse({
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'fullAddress') String? fullAddress,
    @JsonKey(name: 'provinceCode') int? provinceCode,
    @JsonKey(name: 'provinceName') String? provinceName,
    @JsonKey(name: 'wardCode') int? wardCode,
    @JsonKey(name: 'wardName') String? wardName,
  }) = _CreateShopProfileResponse;

  factory CreateShopProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateShopProfileResponseFromJson(json);
}
