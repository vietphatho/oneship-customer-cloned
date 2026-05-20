import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_product_request.freezed.dart';
part 'create_product_request.g.dart';

@freezed
abstract class CreateProductRequest with _$CreateProductRequest {
  const factory CreateProductRequest({
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "price") int? price,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "inventoryId") String? inventoryId,
    @JsonKey(name: "isActive") bool? isActive,
  }) = _CreateProductRequest;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductRequestFromJson(json);
}
