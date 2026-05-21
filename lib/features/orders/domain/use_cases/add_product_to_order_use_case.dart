// import 'package:injectable/injectable.dart';
// import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
// import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';

// @lazySingleton
// class AddProductToOrderUseCase {
//   AddProductToOrderUseCase();

//   Future<List<SelectedProductEntity>> call({
//     required List<SelectedProductEntity> currentProduct,
//     required Map<String, ProductEntity> selectedMap,
//   }) async {
//     final Map<String, SelectedProductEntity> currentMap = {
//       for (final item in currentProduct) item.sku: item,
//     };

//     for (final entry in selectedMap.entries) {
//       final sku = entry.key;
//       final product = entry.value;

//       if (currentMap.containsKey(sku)) {
//         final current = currentMap[sku]!;

//         currentMap[sku] = current.copyWith(quantity: current.quantity + 1);
//       } else {
//         currentMap[sku] = SelectedProductEntity.from(product);
//       }
//     }
//     return currentMap.values.toList();
//   }
// }
