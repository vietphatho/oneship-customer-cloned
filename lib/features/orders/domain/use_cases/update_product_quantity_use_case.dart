import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_selected_entity.dart';

@lazySingleton
class UpdateProductQuantityUseCase {
  UpdateProductQuantityUseCase();

  Future<List<ProductEntitySelected>> call({
    required List<ProductEntitySelected> currentProduct,
    required String sku,
    required ActionType actionType,
  }) async {
    final Map<String, ProductEntitySelected> currentMap = {
      for (final item in currentProduct) item.product.skuCode: item,
    };
    final current = currentMap[sku]!;

    if (actionType == ActionType.increment) {
      currentMap[sku] = current.copyWith(
        quantity: current.quantity + 1,
      );
    } else {
      if (current.quantity > 1) {
        currentMap[sku] = current.copyWith(
          quantity: current.quantity - 1,
        );
      } else {
        currentMap.remove(sku);
      }
    }

    return currentMap.values.toList();
    // final updatedProduct =
    //     currentProduct.map((pro) {
    //       if (pro.product.skuCode == sku) {
    //         if (actionType == ActionType.increment) {
    //           return pro.copyWith(quantity: pro.quantity + 1);
    //         } else {
    //           if (pro.quantity > 1) {
    //             return pro.copyWith(quantity: pro.quantity - 1);
    //           } else {}
    //         }
    //       }
    //       return pro;
    //     }).toList();

    // return updatedProduct;
  }
}
