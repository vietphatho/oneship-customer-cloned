import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';

part 'create_shop_request.freezed.dart';
part 'create_shop_request.g.dart';

@freezed
abstract class CreateShopRequest with _$CreateShopRequest {
  const factory CreateShopRequest({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'shopName') required String shopName,
    @JsonKey(name: 'phone') required String phone,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'fullAddress') required String fullAddress,
    @JsonKey(name: 'provinceCode') required int provinceCode,
    @JsonKey(name: 'provinceName') required String provinceName,
    @JsonKey(name: 'wardCode') required int wardCode,
    @JsonKey(name: 'wardName') required String wardName,
    @JsonKey(name: 'vietMapRefId') required String vietMapRefId,
  }) = _CreateShopRequest;

  factory CreateShopRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateShopRequestFromJson(json);

  factory CreateShopRequest.fromParams(CreateShopParams params) {
    return CreateShopRequest(
      userId: params.userId,
      shopName: params.shopName,
      phone: params.phone,
      email: params.email,
      fullAddress: params.fullAddress,
      provinceCode: params.provinceCode,
      provinceName: params.provinceName,
      wardCode: params.wardCode,
      wardName: params.wardName,
      vietMapRefId: params.vietMapRefId,
    );
  }
}
