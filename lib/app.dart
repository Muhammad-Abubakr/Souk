/// imports from [flutter] package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// imports from local package
import 'package:state_shop/presentation/screens/categories_screen.dart';
import 'package:state_shop/presentation/screens/login_screen.dart';
import 'package:state_shop/presentation/screens/products_overview_screen.dart';
import 'package:state_shop/presentation/screens/user_store_screen.dart';
import 'package:state_shop/presentation/screens/wishlist_screen.dart';
import 'package:state_shop/presentation/widgets/appbar_profile_popup.dart';
import 'package:state_shop/presentation/widgets/main_drawer.dart';

import 'logic/bloc/authentication_bloc.dart';
import 'presentation/widgets/cart_button.dart';

/// [App] is the initial route that is loaded when the application starts (as of now, may change in future)
/// as we may display a [SplashScreen] widget while fetching the applications data from the server.
/// App extends [StatefulWidget] as it maintains a local state for the [BottomNavigationBar] in order to
/// keep track of the screen/page/route is on top of the RouteStack
class App extends StatefulWidget {
  static const routeName = '/app';

  /// we really don't need a key here may remove later
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

/// `State Class` for the App class
class _AppState extends State<App> {
  int screenIdx = 0;
  late final List<Widget> screens;

  /// initState() Does nothing as of now except initializing our data
  @override
  void initState() {
    super.initState();

    /// could have initialized outside of the initState but it's better to follow
    /// best practices and also using State LifeCycle methods to get used to them
    /// however, here we store an instance of every screen in the screen's List<Widget>
    screens = const [
      ProductsOverviewScreen(),
      CategoriesScreen(),
      WishlistScreen(),
      UserStoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Check if the screen is in landscape
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.loggedOut) {
          Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Souk',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'flix',
                ),
          ),
          actions: [
            // ? Search Button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              splashRadius: 24,
            ),

            // ? User Login DropDown
            const ProfilePopUp(),
          ],
        ),

        // ? Drawer
        drawer: MainDrawer(parentContext: context),
        drawerEdgeDragWidth: 20,

        // ? Body
        body: isLandscape
            ? Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: kIsWeb ? 5 : 8,
                    child: NavigationRail(
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.shop_two_outlined),
                          selectedIcon: Icon(Icons.shop_two_rounded),
                          label: Text('shop'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.category_outlined),
                          selectedIcon: Icon(Icons.category),
                          label: Text('categories'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bookmarks_outlined),
                          selectedIcon: Icon(Icons.bookmarks_rounded),
                          label: Text('bookmarks'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.store_outlined),
                          selectedIcon: Icon(Icons.store_rounded),
                          label: Text('my store'),
                        ),
                      ],
                      selectedIndex: screenIdx,
                      onDestinationSelected: (value) => setState(() => screenIdx = value),
                      useIndicator: !kIsWeb,
                      selectedIconTheme: IconThemeData(
                          color: kIsWeb
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.secondary,
                          shadows: kElevationToShadow[kIsWeb ? 1 : 3]),
                      indicatorColor: Theme.of(context).primaryColor,
                      elevation: 4,
                    ),
                  ),
                  Expanded(
                    flex: kIsWeb ? 95 : 92,
                    child: screens[screenIdx],
                  ),
                ],
              )
            : screens[screenIdx],

        // ?  Cart Button
        floatingActionButton: const CartButton(),

        // ? Bottom Navigation Bar
        bottomNavigationBar: !isLandscape ? _buildBottomNavBar(context) : null,
      ),
    );
  }

  // ? Bottom Navigation Bar Builder
  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (value) => setState(() {
        screenIdx = value;
      }),
      currentIndex: screenIdx,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shop_two_outlined),
          activeIcon: Icon(Icons.shop_two_rounded),
          label: 'shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: 'categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmarks_outlined),
          activeIcon: Icon(Icons.bookmarks_rounded),
          label: 'bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          activeIcon: Icon(Icons.store_rounded),
          label: 'my store',
        ),
      ],
    );
  }
}
