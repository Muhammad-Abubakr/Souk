import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/products_bloc.dart';
import '../../logic/bloc/products_events.dart';
import '../widgets/main_drawer.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductsBloc>();
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            splashRadius: 24,
            onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
              arguments: {'loadState': EditProductScreenState.add},
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),

      // ? MainDrawer
      drawer: MainDrawer(parentContext: context),

      // ? ListView for manage product Screen
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (isPortrait ? 0.01 : 0.1),
          vertical: 8,
        ),
        itemBuilder: (context, index) =>
            _buildManageProductWidget(context, productsBloc, index),
        itemCount: productsBloc.state.products.length,
      ),

      // ? Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: {'loadState': EditProductScreenState.add},
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  // ? Individual Manage Product widget builder
  Card _buildManageProductWidget(BuildContext context, ProductsBloc productsBloc, int index) {
    final products = productsBloc.state.products;
    final currentProduct = products[index];

    return Card(
      elevation: 0,
      child: Row(
        children: [
          // ? Product Image
          SizedBox(
            height: MediaQuery.of(context).size.longestSide * 0.15,
            width: MediaQuery.of(context).size.longestSide * 0.1,
            child: Image(
              image: currentProduct.image != null
                  ? Image.file(currentProduct.image!).image
                  : Image.network(currentProduct.imageUrl).image,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(currentProduct.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentProduct.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("Price: \$${currentProduct.price}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: {
                            'productID': currentProduct.id,
                            'loadState': EditProductScreenState.update
                          },
                        ),
                        icon: const Icon(Icons.edit_rounded),
                        color: Colors.teal.shade200,
                        splashRadius: 24,
                        splashColor: Colors.teal.shade200,
                      ),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (builderContext) => AlertDialog(
                            title: const Text("Are you sure?"),
                            content:
                                Text("${currentProduct.title} will be permanently deleted."),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.grey.shade600),
                                ),
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("cancel"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.redAccent.shade100),
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Delete"),
                              )
                            ],
                          ),
                        ).then((result) {
                          if (result != null && result) {
                            productsBloc.add(DeleteProductEvent(productID: currentProduct.id));
                          }
                        }),
                        icon: const Icon(Icons.delete_rounded),
                        color: Colors.redAccent.shade100,
                        splashRadius: 24,
                        splashColor: Colors.redAccent.shade100,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
