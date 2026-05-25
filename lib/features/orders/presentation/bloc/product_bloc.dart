import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/data/enum.dart';
import 'package:oneship_shop/features/orders/data/models/request/create_product_request.dart';
import 'package:oneship_shop/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_shop/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_shop/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_shop/features/orders/domain/use_cases/create_new_product_use_case.dart';
import 'package:oneship_shop/features/orders/domain/use_cases/fetch_products_list_use_case.dart';
import 'package:oneship_shop/features/orders/domain/use_cases/update_product_quantity_use_case.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/product_event.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/product_state.dart';

@lazySingleton
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateNewProductUseCase _createNewProductUseCase;
  final FetchProductsListUseCase _fetchProductsListUseCase;
  final UpdateProductQuantityUseCase _updateProductQuantityUseCase;

  ProductBloc(
    this._createNewProductUseCase,
    this._fetchProductsListUseCase,
    this._updateProductQuantityUseCase,
  ) : super(
        ProductState(
          createProductResource: Resource.success(null),
          productsList: Resource.success(null),
        ),
      ) {
    on<FetchProductsListEvent>(_onFetchProductList);
    on<CreateNewProductEvent>(_onCreateNewProductEvent);
    on<AddProductToSelectedListEvent>(_onAddToSelectedList);
    on<RemoveProductFromSelectedListEvent>(_onRemoveFromSelectedList);
    on<UpdateProductSelectedQtyEvent>(_onUpdateProductQty);
    on<InitUpdateSelectedProductEvent>(_onInitUpdateSelectedProduct);
  }

  FutureOr<void> _onFetchProductList(
    FetchProductsListEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(productsList: Resource.loading()));

    final response = await _fetchProductsListUseCase.call(shopId: event.shopId);

    emit(state.copyWith(productsList: response));
  }

  FutureOr<void> _onCreateNewProductEvent(
    CreateNewProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(createProductResource: Resource.loading()));

    final request = CreateProductRequest(
      shopId: event.shopId,
      sku: event.sku,
      name: event.name,
      price: event.price,
    );

    final response = await _createNewProductUseCase.call(
      shopId: event.shopId,
      request: request,
    );

    emit(state.copyWith(createProductResource: response));
  }

  FutureOr<void> _onAddToSelectedList(
    AddProductToSelectedListEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        productsListSelected: [
          ...state.productsListSelected,
          SelectedProductEntity.fromProductEntity(event.product),
        ],
        selectedCount: state.selectedCount + 1,
      ),
    );
  }

  FutureOr<void> _onRemoveFromSelectedList(
    RemoveProductFromSelectedListEvent event,
    Emitter<ProductState> emit,
  ) {
    final selectedList = List<SelectedProductEntity>.from(
      state.productsListSelected,
    );

    selectedList.removeWhere((e) => e.sku == event.product.sku);

    emit(
      state.copyWith(
        productsListSelected: selectedList,
        selectedCount: selectedList.length,
      ),
    );
  }

  FutureOr<void> _onUpdateProductQty(
    UpdateProductSelectedQtyEvent event,
    Emitter<ProductState> emit,
  ) async {
    final newa = await _updateProductQuantityUseCase.call(
      currentProduct: state.productsListSelected,
      sku: event.skuCode,
      actionType: event.actionType,
    );

    emit(
      state.copyWith(productsListSelected: newa, selectedCount: newa.length),
    );
  }

  FutureOr<void> _onInitUpdateSelectedProduct(
    InitUpdateSelectedProductEvent event,
    Emitter<ProductState> emit,
  ) {
    List<SelectedProductEntity> selectedProducts =
        event.product
            .map(
              (e) => SelectedProductEntity(
                id: e.id ?? "",
                name: e.productName ?? "",
                sku: e.productSku ?? "",
                price: e.unitPrice,
                quantity: e.quantity,
              ),
            )
            .toList();

    emit(
      state.copyWith(
        productsListSelected: selectedProducts,
        selectedCount: selectedProducts.length,
      ),
    );
  }

  void fetchProductsList(String shopId) {
    add(FetchProductsListEvent(shopId));
  }

  void createProduct({
    required String shopId,
    required String name,
    required String sku,
    required int price,
  }) {
    add(
      CreateNewProductEvent(shopId: shopId, name: name, sku: sku, price: price),
    );
  }

  void addToSelectedList(ProductEntity product) {
    add(AddProductToSelectedListEvent(product));
  }

  void removeFromSelectedList(ProductEntity product) {
    add(RemoveProductFromSelectedListEvent(product));
  }

  void updateProductSelectedQty({
    required String sku,
    required CreateOrderProductAction actionType,
  }) {
    add(UpdateProductSelectedQtyEvent(skuCode: sku, actionType: actionType));
  }

  void initUpdateSelectedProduct(List<OrderDetailProductEntity> products) {
    add(InitUpdateSelectedProductEvent(products));
  }
}
