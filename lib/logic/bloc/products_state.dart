import 'package:equatable/equatable.dart';

import '../models/product.dart';

class ProductsState extends Equatable {
  // field
  final List<Product> products;

  // private default constructor
  const ProductsState(this.products);

  @override
  List<Object?> get props => [products];
}

// Initial State
class ProductsStateInitial extends ProductsState {
  const ProductsStateInitial(List<Product> products) : super(products);
}

// Updated State
class ProductsStateUpdate extends ProductsState {
  const ProductsStateUpdate(List<Product> products) : super(products);
}
