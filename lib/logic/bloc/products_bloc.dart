import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/products_repository.dart';
import '../models/product.dart';
import 'products_events.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvents, ProductsState> {
  // Initializing the state
  ProductsBloc() : super(const ProductsStateInitial(products)) {
    on<DeleteProductEvent>(_deleteProductEventHandler);
    on<AddProductEvent>(_addProductEventHandler);
    on<UpdateProductEvent>(_updateProductEventHandler);
  }

  // Event handlers
  FutureOr<void> _deleteProductEventHandler(
      DeleteProductEvent event, Emitter<ProductsState> emit) {
    // find the product
    Product product = findByID(event.productID);

    // create a new list
    final updatedState = [...state.products];
    // and remove the product
    updatedState.remove(product);

    // emit the new state
    emit(ProductsStateUpdate(updatedState));
  }

  // Add product event handler
  FutureOr<void> _addProductEventHandler(AddProductEvent event, Emitter<ProductsState> emit) {
    // updating the local state
    emit(ProductsStateUpdate(
        [event.product.copyWith(id: _generateproductID()), ...state.products]));
  }

  // Update Product event handler
  FutureOr<void> _updateProductEventHandler(
      UpdateProductEvent event, Emitter<ProductsState> emit) {
    // get the index of the product with the same id
    final int productIdx = _getIdx(event.product.id);

    // create a new modifiable list from the old state
    List<Product> updatedState = [...state.products];

    // remove the product
    updatedState.removeAt(productIdx);

    // insert new product at the same index
    updatedState.insert(productIdx, event.product);

    // emit the new State
    emit(ProductsStateUpdate(updatedState));
  }

  // helper functions
  Product findByID(String productID) {
    return state.products.firstWhere((element) => element.id == productID);
  }

  int _getIdx(String productID) {
    return state.products.indexWhere((element) => element.id == productID);
  }

  String _generateproductID() {
    // we will go with the hex system for the id
    return (state.products.length + 1).toRadixString(16);
  }
}
