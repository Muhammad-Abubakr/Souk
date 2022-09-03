import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';

import '../../logic/bloc/cart_bloc.dart';
import '../../logic/bloc/orders_bloc.dart';
import '../widgets/cart_items_list.dart';
import '../widgets/feedback_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final cartBloc = context.watch<CartBloc>();
    final mediaQuery = MediaQuery.of(context);

    return cartBloc.state.cartProducts.isEmpty
        // ? If the cart is empty
        ? FeedbackWidget(
            title: "Nothing here right now!",
            image: Image(
              image: Image.asset("lib/assets/images/undraw_empty_cart.png").image,
              width: MediaQuery.of(context).size.width * (isPortrait ? 0.6 : 0.3),
            ),
            buttonLabel: 'Back to store',
            buttonIcon: Icons.store_rounded,
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.settings.name == App.routeName),
          )

        // ? If cart is not empty
        : Scaffold(
            appBar: AppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  image: Image.asset("lib/assets/images/undraw_cart.png").image,
                  fit: BoxFit.fitHeight,
                  height: (MediaQuery.of(context).size.height * 0.2) -
                      MediaQuery.of(context).padding.top,
                ),
              ),
              elevation: 2,
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).backgroundColor,
              toolbarHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // ? Cart Items List
                const CartItemsList(),

                // ? Total and Place Order Button Container
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  height: mediaQuery.size.longestSide * 0.08,
                  width: mediaQuery.size.width * (isPortrait ? 0.8 : 0.4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).backgroundColor
                    ]),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Total: \$${cartBloc.state.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        // ! -------------- Place the order -------------- //
                        context.read<OrdersBloc>().add(PlaceOrderEvent());

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (buildContext) {
                              return FeedbackWidget(
                                title: "Hooray! \n Your order has been placed",
                                image: Image(
                                  image: Image.asset("lib/assets/images/order_confirmed.png")
                                      .image,
                                  width: MediaQuery.of(context).size.width *
                                      (isPortrait ? 0.6 : 0.3),
                                ),
                                buttonLabel: 'Great! Back to store',
                                buttonIcon: Icons.celebration_rounded,
                                onPressed: () => Navigator.of(buildContext)
                                    .popUntil((route) => route.settings.name == App.routeName),
                              );
                            },
                          ),
                          // only when the feedback is being popped
                          // clear the cart because if we don't do so
                          // CartScreen gets rebuilt because of state change
                          // and because of that glitches occur.
                        ).then((_) => cartBloc.add(ClearCartEvent()));

                        // ! --------------------------------------------- //
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Theme.of(context).primaryColor),
                      ),
                      icon: const Icon(
                        Icons.shopping_cart_checkout_rounded,
                      ),
                      label: const Text("Place order now"),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
