import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_shop/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_shop/features/orders/domain/entities/products_list_entity.dart';

part 'product_state.freezed.dart';

@freezed
abstract class ProductState with _$ProductState {
  factory ProductState({
    required Resource<ProductEntity?> createProductResource,

    required Resource<ProductsListEntity?> productsList,
    @Default([]) List<SelectedProductEntity> productsListSelected,

    @Default(0) int selectedCount,
  }) = _ProductState;
}

extension ProductStateX on ProductState {
  bool isSelected(String sku) {
    final productSelected = productsListSelected.firstWhereOrNull(
      (e) => e.sku == sku,
    );
    if (productSelected != null) {
      return true;
    }
    return false;
  }

  int getCalculatedTotalQuantity() {
    int totalQuantity = 0;

    for (var pro in productsListSelected) {
      totalQuantity += pro.quantity;
    }

    return totalQuantity;
  }

  int getCalculatedTotalAmount() {
    int totalAmount = 0;

    for (var pro in productsListSelected) {
      totalAmount += pro.calculatedTotalAmount;
    }

    return totalAmount;
  }
}