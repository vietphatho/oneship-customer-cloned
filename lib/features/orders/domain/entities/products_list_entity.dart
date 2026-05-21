import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/products_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

part 'products_list_entity.freezed.dart';

@freezed
abstract class ProductsListEntity with _$ProductsListEntity {
  const factory ProductsListEntity({
    List<ProductEntity>? items,
    DateTime? nextCursor,
    bool? hasMore,
    int? count,
  }) = _ProductsListEntity;

  factory ProductsListEntity.from(ProductsListResponse dto) {
    return ProductsListEntity(
      items: dto.items?.map((e) => ProductEntity.from(e)).toList(),
      nextCursor: dto.nextCursor,
      hasMore: dto.hasMore,
      count: dto.count,
    );
  }
}
