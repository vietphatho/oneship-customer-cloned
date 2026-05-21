import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_list_response.freezed.dart';
part 'products_list_response.g.dart';

@freezed
abstract class ProductsListResponse with _$ProductsListResponse {
  const factory ProductsListResponse({
    @JsonKey(name: "items") List<ProductResponse>? items,
    @JsonKey(name: "nextCursor") DateTime? nextCursor,
    @JsonKey(name: "hasMore") bool? hasMore,
    @JsonKey(name: "count") int? count,
  }) = _ProductsListResponse;

  factory ProductsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsListResponseFromJson(json);
}

@freezed
abstract class ProductResponse with _$ProductResponse {
  const factory ProductResponse({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "price") int? price,
    @JsonKey(name: "inventoryId") String? inventoryId,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _ProductResponse;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => _$ProductResponseFromJson(json);
}
