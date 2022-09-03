import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import 'products_bloc.dart';
import 'products_state.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // ? since we need latest products state we will need to subscribe to ProductsBloc
  final ProductsBloc _productsBloc;
  late List<Product> _products;

  CartBloc(this._productsBloc) : super(const CartState.initial()) {
    // ! updating our local products as the ProductsState changes
    _products = _productsBloc.state.products;

    _productsBloc.stream.listen(_productsBlocChangeHandler);

    // ! Event handlers
    on<AddItemToCartEvent>(_addItemToCart);
    on<RemoveItemFromCartEvent>(_removeItemFromCart);
    on<ReduceItemQuantityEvent>(_reduceItemQuantity);
    on<ClearCartEvent>(_clearCartEventHandler);

    // ! Private events
    on<_PeriodicStateTest>((event, emit) => emit(
          CartState.update(
            cartProducts: event.updatedCartState,
            totalPrice: _getTotal(event.updatedCartState),
          ),
        ));
  }

  // ? Add item to cart event handler
  FutureOr<void> _addItemToCart(AddItemToCartEvent event, Emitter<CartState> emit) {
    // getting the product
    final Product product = _getProduct(event.productID);

    // checking if the product is already in the cart list
    int itemIdx = state.cartProducts.indexWhere((element) => element.product == product);

    // if the item is not present
    if (itemIdx == -1) {
      // updating the state
      final updatedList = [
        ...state.cartProducts,
        CartItem(product: product, quantity: 1),
      ];

      emit(
        CartState.update(
          cartProducts: updatedList,
          totalPrice: _getTotal(updatedList),
        ),
      );
    } else {
      // if the item is present
      // creating a new List from the old state
      final List<CartItem> newCartProductsList = [...state.cartProducts];

      // get the item and remove from the new List
      final CartItem oldItem = newCartProductsList.removeAt(itemIdx);

      // insert the product with the updated quantity
      newCartProductsList.insert(
        itemIdx,
        oldItem.copyWith(
            quantity: oldItem.quantity + 1, product: Product.copyWith(oldItem.product)),
      );

      // update the state
      emit(CartState.update(
          cartProducts: newCartProductsList, totalPrice: _getTotal(newCartProductsList)));
    }
  }

  // ? Remove Item from Cart Event Handler
  FutureOr<void> _removeItemFromCart(RemoveItemFromCartEvent event, Emitter<CartState> emit) {
    // create a new List from state.cartProducts
    final List<CartItem> newCartProductsList = [...state.cartProducts];

    // get the product index
    int productIdx =
        newCartProductsList.indexWhere((element) => element.product.id == event.productID);

    // remove the product
    newCartProductsList.removeAt(productIdx);

    // emit the updated state
    emit(CartState.update(
        cartProducts: newCartProductsList, totalPrice: _getTotal(newCartProductsList)));
  }

  // ? Reduce Item quantity event handler
  FutureOr<void> _reduceItemQuantity(ReduceItemQuantityEvent event, Emitter<CartState> emit) {
    // get the product index matching the product ID
    final productidx =
        state.cartProducts.indexWhere((element) => element.product.id == event.productID);

    // get the product
    final product = state.cartProducts[productidx];

    // 1- check if the item quantity after decrement is equal to zero if it is delete the item from cart
    if (product.quantity - 1 == 0) {
      add(RemoveItemFromCartEvent(event.productID));
    }
    // 2- else update the Quantity
    else {
      // remove the product
      state.cartProducts.remove(product);

      // create new List from the state list
      final updatedStateList = [...state.cartProducts];

      // insert the product in the old index
      updatedStateList.insert(productidx, product.copyWith(quantity: product.quantity - 1));

      // emit the new updated list

      emit(CartState.update(
          cartProducts: updatedStateList, totalPrice: _getTotal(updatedStateList)));
    }
  }

  // ? Clear Cart Event handler
  FutureOr<void> _clearCartEventHandler(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState.initial());
  }

  // ? helper functions
  Product _getProduct(String productID) {
    return _products.firstWhere((element) => element.id == productID);
  }

  bool contains(String productID) {
    return state.cartProducts.indexWhere((element) => element.product.id == productID) > -1;
  }

  double _getTotal(List<CartItem> updatedList) {
    return updatedList.fold(
      0,
      (previousValue, element) => (previousValue) + element.product.price * element.quantity,
    );
  }

  // * printing the events
  @override
  void onEvent(CartEvent event) {
    super.onEvent(event);

    print(event);
  }

  // ! Closing the Subscriptions
  @override
  Future<void> close() {
    _productsBloc.close();
    return super.close();
  }

  //  Method that is run everytime there is an event or change in the products Bloc
  void _productsBlocChangeHandler(ProductsState productsState) {
    // update the products state
    _products = productsState.products;

    // then for each item in the cartsState check if every item is still available
    // if not remove it from the cart
    for (CartItem item in state.cartProducts) {
      if (!_products.contains(item.product)) {
        // create a new list from the cartState and
        // remove the item
        final List<CartItem> updatedList = [...state.cartProducts]..remove(item);

        // emit the new state
        add(_PeriodicStateTest(updatedCartState: updatedList));
      }
    }
  }
}
