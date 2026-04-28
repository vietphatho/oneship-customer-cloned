import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/create_new_product_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';

@lazySingleton
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateNewProductUseCase _createNewProductUseCase;

  ProductBloc(this._createNewProductUseCase)
    : super(ProductState(products: Resource.success([]))) {
    on<CreateNewProductEvent>(_onCreateNewProductEvent);
    on<ToggleProductSelectionEvent>(_onToggleProductSelectionEvent);
    on<ProductResetSelectedEvent>(_onProductResetSelectedEvent);
  }

  Future<void> _onCreateNewProductEvent(
    CreateNewProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(products: state.products!.copyWith(state: Result.loading)),
    );

    final response = await _createNewProductUseCase(
      newProduct: event.product,
      currentProducts: state.products?.data ?? [],
      currentSelectedCount: state.selectedCount,
    );

    final updatedProducts = response['products'] as List<ProductEntity>;
    final newSelectedCount = response['selectedCount'];

    emit(
      state.copyWith(
        products: Resource.success(updatedProducts),
        selectedCount: newSelectedCount,
      ),
    );
  }

  Future<void> _onToggleProductSelectionEvent(
    ToggleProductSelectionEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentProducts = state.products?.data ?? [];
    var newSelectedCount = state.selectedCount;

    final updatedProducts =
        currentProducts.map((product) {
          if (product.skuCode == event.skuCode) {
            newSelectedCount =
                state.selectedCount + (!product.isSelected ? 1 : -1);
            return product.copyWith(isSelected: !product.isSelected);
          }
          return product;
        }).toList();

    emit(
      state.copyWith(
        products: Resource.success(updatedProducts),
        selectedCount: newSelectedCount,
      ),
    );
  }

  void createNewProduct(ProductEntity product) {
    add(CreateNewProductEvent(product));
  }

  void toggleProductSelection(String skuCode) {
    add(ToggleProductSelectionEvent(skuCode));
  }

  void resetProductSelected() {
    add(ProductResetSelectedEvent());
  }

  Future<void> _onProductResetSelectedEvent(
    ProductResetSelectedEvent event,
    Emitter<ProductState> emit,
  ) async {
    final updatedProducts =
        state.products!.data
            ?.map((pro) => pro.copyWith(isSelected: false))
            .toList();
    emit(
      state.copyWith(
        products: Resource.success(updatedProducts!),
        selectedCount: 0,
      ),
    );
  }
}
