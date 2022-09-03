import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/cart_bloc.dart';
import 'cart_item.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accessing the Cart Bloc
    final cartBloc = context.watch<CartBloc>();
    final cartItems = cartBloc.state.cartProducts;
    final mediaQuery = MediaQuery.of(context);
    bool isPortrait = mediaQuery.orientation == Orientation.portrait;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20,
        right: mediaQuery.size.width * (isPortrait ? 0.05 : 0.2),
        left: mediaQuery.size.width * (isPortrait ? 0.05 : 0.2),
        bottom: mediaQuery.size.longestSide * 0.1,
      ),
      children:
          cartItems.map((item) => CartItemWidget(cartBloc: cartBloc, item: item)).toList(),
    );
  }
}
