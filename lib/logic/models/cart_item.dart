// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItem extends Equatable {
  // Cart Item comprises of the following attributes
  final Product product;
  final int quantity;
  const CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() => 'CartItem(product: $product, quantity: $quantity)';

  @override
  List<Object?> get props => [product, quantity];
}
