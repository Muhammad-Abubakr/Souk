part of 'cart_bloc.dart';

// specifying the events that will be sent from the UI layer
// so that we can intercept and react to those events
abstract class CartEvent {}

// add to cart event
class AddItemToCartEvent implements CartEvent {
  final String productID;

  AddItemToCartEvent(this.productID);
}

// reduce item quantity from cart event
class ReduceItemQuantityEvent implements CartEvent {
  final String productID;

  ReduceItemQuantityEvent(this.productID);
}

// increase item quantity from cart event
class IncreaseItemQuantityEvent implements CartEvent {
  final String productID;

  IncreaseItemQuantityEvent(this.productID);
}

// remove item from cart
class RemoveItemFromCartEvent implements CartEvent {
  final String productID;

  RemoveItemFromCartEvent(this.productID);
}

// remove item from cart
class ClearCartEvent implements CartEvent {}

// ? Private events
// Periodic State test for cart to keep cart items updated
class _PeriodicStateTest implements CartEvent {
  final List<CartItem> updatedCartState;

  _PeriodicStateTest({required this.updatedCartState});
}
