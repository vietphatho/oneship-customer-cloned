import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  factory ProductEntity({
    @Default("") String productName,
    @Default("") String skuCode,
    @Default(0) int price,
    @Default(false) bool isSelected
  }) = _ProductEntity;
}
