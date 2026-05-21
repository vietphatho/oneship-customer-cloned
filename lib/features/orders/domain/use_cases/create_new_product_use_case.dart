import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_product_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class CreateNewProductUseCase {
  final OrdersRepository _ordersRepository;
  CreateNewProductUseCase(this._ordersRepository);

  Future<Resource<ProductEntity>> call({
    required String shopId,
    required CreateProductRequest request,
  }) async {
    final response = await _ordersRepository.createProduct(shopId: shopId, body: request);

    return response;
  }
}
