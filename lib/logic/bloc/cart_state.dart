part of 'cart_bloc.dart';

class CartState extends Equatable {
  // state attributes
  final List<CartItem> cartProducts;
  final double totalPrice;

  // private zero argument constructor
  const CartState._()
      : cartProducts = const [],
        totalPrice = 0;

  // initial state constructor
  const CartState.initial() : this._();

  // update state constructor
  const CartState.update({required this.cartProducts, required this.totalPrice});

  @override
  List<Object> get props => [cartProducts, totalPrice];
}
