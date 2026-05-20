import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/products_list_response.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    @Default("") String id,
    @Default("") String shopId,
    @Default("") String sku,
    @Default("") String name,
    String? description,
    @Default(0) int price,
    String? inventoryId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductEntity;

  factory ProductEntity.from(ProductResponse dto) {
    return ProductEntity(
      id: dto.id ?? "",
      shopId: dto.shopId ?? "",
      sku: dto.sku ?? "",
      name: dto.name ?? "",
      description: dto.description,
      price: dto.price ?? 0,
      inventoryId: dto.inventoryId,
      isActive: dto.isActive,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}
