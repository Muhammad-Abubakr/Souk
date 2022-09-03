// ignore_for_file: public_member_api_docs, sort_constructors_first
// Specifying events that can be received from the user with the data
// from the presentation layer
import '../models/product.dart';

abstract class ProductsEvents {}

// Delete Product Permanentaly Event
class DeleteProductEvent extends ProductsEvents {
  final String productID;

  DeleteProductEvent({
    required this.productID,
  });
}

// Add Product Event
class AddProductEvent extends ProductsEvents {
  final Product product;

  AddProductEvent({required this.product});
}

// Update Product Event
class UpdateProductEvent extends ProductsEvents {
  final Product product;

  UpdateProductEvent({required this.product});
}
