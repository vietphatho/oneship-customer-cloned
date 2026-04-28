import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

@lazySingleton
class CreateNewProductUseCase {
  CreateNewProductUseCase();

  Future<Map<String, dynamic>> call({
    required ProductEntity newProduct,
    required List<ProductEntity> currentProducts,
    required int currentSelectedCount
  }) async {
    List<ProductEntity> updatedProducts = List.from(currentProducts)
      ..add(newProduct);
    final newSelectedCount = currentSelectedCount + 1;

    return {
      'selectedCount': newSelectedCount,
      'products': updatedProducts,
    };
  }
}