import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';

part 'create_new_product_response_entity.freezed.dart'; 

@freezed
abstract class CreateNewProductResponseEntity with _$CreateNewProductResponseEntity {
  factory CreateNewProductResponseEntity({
    @Default(0) int newSelectedCount,
    @Default([]) List<ProductEntity> updatedProducts
  }) = _CreateNewProductResponseEntity;
}