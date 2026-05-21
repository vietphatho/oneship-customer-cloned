import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class FetchProductsListEvent extends ProductEvent {
  final String shopId;

  const FetchProductsListEvent(this.shopId);
}

class InitUpdateSelectedProductEvent extends ProductEvent {
  final List<OrderDetailProductEntity> product;

  const InitUpdateSelectedProductEvent(this.product);
}

class CreateNewProductEvent extends ProductEvent {
  final String shopId;
  final String name;
  final String sku;
  final int price;

  const CreateNewProductEvent({
    required this.shopId,
    required this.name,
    required this.sku,
    required this.price,
  });
}

class AddProductToSelectedListEvent extends ProductEvent {
  final ProductEntity product;

  const AddProductToSelectedListEvent(this.product);
}

class RemoveProductFromSelectedListEvent extends ProductEvent {
  final ProductEntity product;

  const RemoveProductFromSelectedListEvent(this.product);
}

class UpdateProductSelectedQtyEvent extends ProductEvent {
  final String skuCode;
  final CreateOrderProductAction actionType;

  const UpdateProductSelectedQtyEvent({required this.skuCode, required this.actionType});
}
