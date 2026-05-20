import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

part 'selected_product_entity.freezed.dart';

@freezed
abstract class SelectedProductEntity with _$SelectedProductEntity {
  const SelectedProductEntity._();

  const factory SelectedProductEntity({
    @Default("") String id,
    @Default("") String name,
    @Default("") String sku,
    @Default(0) int price,
    @Default(1) int quantity,
  }) = _SelectedProductEntity;

  factory SelectedProductEntity.fromProductEntity(ProductEntity model) {
    return SelectedProductEntity(
      id: model.id,
      name: model.name,
      sku: model.sku,
      price: model.price,
      quantity: 1,
    );
  }
  
   SelectedProduct toDto() {
    return SelectedProduct(
      id: id,
      name: name,
      sku: sku,
      price: price,
      qty: quantity,
    );
  }
}

extension SelectedProductEntityX on SelectedProductEntity {
  int get calculatedTotalAmount => price * quantity;
}
