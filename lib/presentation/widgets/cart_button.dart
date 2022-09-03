import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/cart_bloc.dart';
import '../screens/cart_screen.dart';
import 'badge_icon.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // accessing the cart Bloc
    final cartBloc = context.watch<CartBloc>();

    return BadgeIconButton(
        badgeAlignment: Alignment.topRight,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        badgeForeground: Theme.of(context).primaryColor,
        badgeBackground: Theme.of(context).colorScheme.secondary,
        splashColor: Theme.of(context).primaryColor,
        value: cartBloc.state.cartProducts.length,
        // ignore: prefer_const_constructors
        icon: Icon(
          cartBloc.state.cartProducts.isNotEmpty
              ? Icons.shopping_cart_checkout_rounded
              : Icons.shopping_cart,
        ),
        onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName));
  }
}
