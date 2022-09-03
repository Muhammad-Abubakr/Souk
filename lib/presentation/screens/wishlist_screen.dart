import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/favourites_bloc.dart';
import '../widgets/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final favouritesBloc = context.watch<FavouritesBloc>();
    final favouriteItems = favouritesBloc.state.favourites;

    return favouriteItems.isEmpty
        ? Center(
            child: Image(
              image: Image.asset('lib/assets/images/undraw_wishlist.png').image,
              height: MediaQuery.of(context).size.longestSide * 0.2,
              fit: BoxFit.cover,
            ),
          )
        : GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.05),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: MediaQuery.of(context).size.longestSide * 0.3,
              crossAxisCount: isPortrait ? 2 : 4,
            ),
            itemBuilder: ((context, index) =>
                ProductWidget(productID: favouriteItems[index].id)),
            itemCount: favouriteItems.length,
          );
  }
}
