import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class CreateNewProductEvent extends ProductEvent {
  final ProductEntity product;

  const CreateNewProductEvent(this.product);
}

class ToggleProductSelectionEvent extends ProductEvent {
  final String skuCode;

  const ToggleProductSelectionEvent(this.skuCode);
}


class ProductResetSelectedEvent extends ProductEvent {
  ProductResetSelectedEvent();
}
