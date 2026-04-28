import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

part 'product_state.freezed.dart';

@freezed
abstract class ProductState with _$ProductState {
  factory ProductState({
    Resource<List<ProductEntity>>? products,
    @Default(0) int selectedCount,
  }) = _ProductState;
}

extension ProductStateX on ProductState {
  Map<String, ProductEntity> getSelectedProducts() {
    final selectedProducts =
        products?.data?.where((pro) => pro.isSelected).toList() ?? [];

    return {
      for (final pro in selectedProducts)
        pro.skuCode: pro,
    };
  }
}