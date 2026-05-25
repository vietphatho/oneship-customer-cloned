import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/domain/entities/products_list_entity.dart';
import 'package:oneship_shop/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchProductsListUseCase {
  final OrdersRepository _repository;

  FetchProductsListUseCase(this._repository);

  Future<Resource<ProductsListEntity>> call({
    required String shopId,
    String? cursor,
    int limit = 30,
  }) {
    return _repository.fetchProductsList(
      shopId: shopId,
      cursor: cursor,
      limit: limit,
    );
  }
}
