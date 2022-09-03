import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/products_bloc.dart';
import 'product_widget.dart';

class ProductsXListView extends StatelessWidget {
  const ProductsXListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.read<ProductsBloc>();

    // ? getting the Products from the Provider (solving prop drilling)
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.longestSide * 0.3,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemExtent: MediaQuery.of(context).size.longestSide * 0.2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (builderContext, index) =>
            ProductWidget(productID: productsBloc.state.products[index].id),
        itemCount: productsBloc.state.products.length,
      ),
    );
  }
}
