import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

part 'product_selected_entity.freezed.dart';

@freezed
abstract class ProductEntitySelected with _$ProductEntitySelected {
  factory ProductEntitySelected({
    required ProductEntity product,
    @Default(1) int quantity,
  }) = _ProductEntitySelected;
}

extension ProductEntitySelectedX on ProductEntitySelected {
  int get calculatedTotalAmount => product.price * quantity;
}
