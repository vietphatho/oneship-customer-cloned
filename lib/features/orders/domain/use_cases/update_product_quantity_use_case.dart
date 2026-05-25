import 'package:injectable/injectable.dart';
import 'package:oneship_shop/features/orders/data/enum.dart';
import 'package:oneship_shop/features/orders/domain/entities/selected_product_entity.dart';

@lazySingleton
class UpdateProductQuantityUseCase {
  UpdateProductQuantityUseCase();

  Future<List<SelectedProductEntity>> call({
    required List<SelectedProductEntity> currentProduct,
    required String sku,
    required CreateOrderProductAction actionType,
  }) async {
    final Map<String, SelectedProductEntity> currentMap = {
      for (final item in currentProduct) item.sku: item,
    };
    final current = currentMap[sku]!;

    if (actionType == CreateOrderProductAction.increment) {
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
  }
}
