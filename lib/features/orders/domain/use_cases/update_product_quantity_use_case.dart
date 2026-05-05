import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_selected_entity.dart';

@lazySingleton
class UpdateProductQuantityUseCase {
  UpdateProductQuantityUseCase();

  Future<List<ProductEntitySelected>> call({
    required List<ProductEntitySelected> currentProduct,
    required String sku,
    required CreateOrderProductAction actionType,
  }) async {
    final Map<String, ProductEntitySelected> currentMap = {
      for (final item in currentProduct) item.product.skuCode: item,
    };
    final current = currentMap[sku]!;

    if (actionType == CreateOrderProductAction.increment) {
      currentMap[sku] = current.copyWith(quantity: current.quantity + 1);
    } else {
      if (current.quantity > 1) {
        currentMap[sku] = current.copyWith(quantity: current.quantity - 1);
      } else {
        currentMap.remove(sku);
      }
    }

    return currentMap.values.toList();
  }
}
