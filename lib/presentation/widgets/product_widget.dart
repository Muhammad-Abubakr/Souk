import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/cart_bloc.dart';
import '../../logic/bloc/favourites_bloc.dart';
import '../../logic/bloc/products_bloc.dart';
import '../screens/product_details_screen.dart';

enum ProductEvents {
  toggleFavourite,
}

class ProductWidget extends StatelessWidget {
  final String productID;

  const ProductWidget({Key? key, required this.productID}) : super(key: key);

  @override
  build(BuildContext context) {
    final productsBloc = context.read<ProductsBloc>();
    final currentProduct =
        productsBloc.state.products.firstWhere((other) => productID == other.id);
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final favouritesBloc = context.read<FavouritesBloc>();

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.longestSide * 0.2,
          child: GridTile(
            // ? List Tile containing product rating in the trailing
            header: ListTile(
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white70,
                      ),
                      child: Text(
                        '5.0',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              letterSpacing: -0.5,
                            ),
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            // ? Card wrapped around product Image
            child: Card(
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),

              // ? Product image gesture detector
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routeName,
                  arguments: currentProduct.id,
                ),

                // ? Product Image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: currentProduct.image != null
                        ? Image.file(currentProduct.image!).image
                        : Image.network(currentProduct.imageUrl).image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        GridTileBar(
          // ? Product Title
          title: Text(
            currentProduct.title,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              color: Colors.black87,
            ),
            maxLines: 1,
          ),

          // ? Product Price
          subtitle: Text(
            "\$${currentProduct.price.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          // ? Add to Cart button
          trailing: Row(
            children: [
              // ? Bookmark Icon
              InkWell(
                onTap: () {
                  favouritesBloc.add(ToggleFavouriteEvent(currentProduct.id));

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text(
                        !favouritesBloc.contains(productID)
                            ? 'Bookmark added'
                            : 'Bookmark removed',
                      ),
                      action: SnackBarAction(
                        label: 'undo',
                        onPressed: () =>
                            favouritesBloc.add(ToggleFavouriteEvent(currentProduct.id)),
                      ),
                    ),
                  );
                },
                child: Builder(
                  builder: (buildContext) {
                    buildContext.select(
                      (FavouritesBloc bloc) => bloc.state.favourites,
                    );

                    return Icon(
                      !favouritesBloc.contains(productID)
                          ? Icons.bookmark_add_outlined
                          : Icons.bookmark_added_rounded,
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  cartBloc.add(AddItemToCartEvent(productID));

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text(
                        '${currentProduct.title} added to cart',
                      ),
                      action: SnackBarAction(
                        label: 'undo',
                        onPressed: () =>
                            cartBloc.add(ReduceItemQuantityEvent(currentProduct.id)),
                      ),
                    ),
                  );
                },
                splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
                splashRadius: 24,
                icon: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
