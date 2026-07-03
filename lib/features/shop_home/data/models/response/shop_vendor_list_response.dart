import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/shop_vendor_response.dart';

class ShopVendorListResponse {
  const ShopVendorListResponse({this.items = const [], this.meta});

  final List<ShopVendorResponse> items;
  final BaseMetaResponse? meta;

  factory ShopVendorListResponse.fromJson(Map<String, dynamic> json) {
    return ShopVendorListResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(ShopVendorResponse.fromJson)
              .toList() ??
          const [],
      meta: json['meta'] is Map<String, dynamic>
          ? BaseMetaResponse.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}
