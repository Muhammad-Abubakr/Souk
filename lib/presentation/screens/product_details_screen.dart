import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/products_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String routeArgs = ModalRoute.of(context)!.settings.arguments as String;
    final String pID = routeArgs;
    final productsBloc = context.read<ProductsBloc>();
    final thisProduct = productsBloc.state.products.firstWhere((product) => product.id == pID);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(thisProduct.title),
      ),
    );
  }
}
