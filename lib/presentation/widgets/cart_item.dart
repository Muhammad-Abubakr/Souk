import 'package:flutter/material.dart';

import '../../logic/bloc/cart_bloc.dart';
import '../../logic/models/cart_item.dart';
import '../../logic/models/product.dart';

class CartItemWidget extends StatelessWidget {
  CartItemWidget({
    Key? key,
    required this.cartBloc,
    required this.item,
  }) : super(key: key) {
    product = item.product;
    productQuantity = item.quantity;
  }

  final CartBloc cartBloc;
  final CartItem item;
  late final Product product;
  late final int productQuantity;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.only(right: mediaQuery.size.width * 0.1),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.redAccent,
            ),
            child: const Icon(Icons.delete_sweep, color: Colors.white),
          ),
          confirmDismiss: (direction) => showDialog(
            context: context,
            builder: (builderCtx) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('cancel')),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('confirm')),
              ],
              title: const Text("Confirm Dismissle"),
              content: const Text('Do you really want to remove this item?'),
            ),
          ),
          onDismissed: (direction) => {cartBloc.add(RemoveItemFromCartEvent(product.id))},
          key: UniqueKey(),
          child: Row(
            children: [
              SizedBox(
                width: mediaQuery.size.longestSide * 0.1,
                height: mediaQuery.size.longestSide * 0.1,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      image: product.image != null
                          ? Image.file(product.image!).image
                          : Image.network(product.imageUrl).image,
                      fit: BoxFit.cover,
                      width: mediaQuery.size.longestSide * 0.1,
                      height: mediaQuery.size.longestSide * 0.1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: IconButton(
                    onPressed: () => cartBloc.add(ReduceItemQuantityEvent(product.id)),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Text("\$${product.price}"),
                      Text("Quantity: $productQuantity"),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => cartBloc.add(AddItemToCartEvent(product.id)),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
