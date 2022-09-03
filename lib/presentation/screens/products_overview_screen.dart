import 'package:flutter/material.dart';

import '../widgets/products_x_listview.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.shortestSide * 0.05,
            ),
            child: Image(
              image: Image.asset("lib/assets/images/undraw_shopping_2.png").image,
              height: MediaQuery.of(context).size.longestSide * 0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                  'Featured',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  color: Theme.of(context).primaryColor,
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  splashRadius: 20,
                  tooltip: 'see more items',
                )
              ],
            ),
          ),

          // ? Featured Products List View
          const ProductsXListView(),
        ],
      ),
    );
  }
}
