import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../screens/manage_products_screen.dart';
import '../screens/orders_history_screen.dart';
import '../screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  final BuildContext parentContext;

  const MainDrawer({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Drawer(
      elevation: 1,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ? Logo Branding
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'flix',
                  ),
              'Souk',
            ),
          ),

          // ? ListView ListTiles for Navigation
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(kIsWeb && isLandscape ? 0 : 32),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerListTileWithInkWell(
                    App.routeName,
                    'Shop',
                    Icons.shop_rounded,
                    context,
                  ),
                  _buildDrawerListTileWithInkWell(
                    OrdersHistoryScreen.routeName,
                    'Orders',
                    Icons.history_rounded,
                    context,
                  ),
                  _buildDrawerListTileWithInkWell(
                    ManageProductsScreen.routeName,
                    'Manage Products',
                    Icons.edit_rounded,
                    context,
                  ),
                  _buildDrawerListTileWithInkWell(
                    SettingsScreen.routeName,
                    'Settings',
                    Icons.settings,
                    context,
                  ),
                ],
              ),
            ),
          ),
          // if (!kIsWeb)
          //   TextButton.icon(
          //     style: ButtonStyle(
          //         foregroundColor:
          //             MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)),
          //     onPressed: () => showDialog(
          //         context: context,
          //         builder: (builderContext) => AlertDialog(
          //               // ignore: prefer_const_constructors
          //               title: Text(
          //                 "Alert",
          //                 // ignore: prefer_const_constructors
          //                 style: TextStyle(color: Colors.grey.shade600),
          //               ),
          //               content: Text(
          //                 "Do you really want to exit the application?",
          //                 // ignore: prefer_const_constructors
          //                 style: TextStyle(color: Colors.grey.shade600),
          //               ),
          //               actions: [
          //                 TextButton(child: const Text('yes'), onPressed: () => exit(0)),
          //                 TextButton(
          //                     child: const Text('no'),
          //                     onPressed: () => Navigator.of(context).pop()),
          //               ],
          //             )),
          //     icon: const Icon(Icons.exit_to_app_rounded),
          //     label: const Text('Exit Souk'),
          //   ),
        ],
      ),
    );
  }

  Widget _buildDrawerListTileWithInkWell(
    String routeName,
    String title,
    IconData iconData,
    BuildContext context,
  ) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      onTap: () =>
          // if the route is already mounted don't push it
          !(ModalRoute.of(parentContext)!.settings.name == routeName)
              ?

              // if not mounted
              Navigator.of(context).pushReplacementNamed(routeName)

              // if mounted pop off the drawer
              : Navigator.of(context).pop(),
      child: ListTile(
        style: ListTileStyle.drawer,
        selected: ModalRoute.of(context)!.settings.name == routeName,
        selectedColor: Theme.of(context).primaryColor,
        textColor: Colors.black45,
        iconColor: Colors.black45,
        leading: Icon(iconData),
        title: Text(title),
        trailing: ModalRoute.of(context)!.settings.name == routeName
            ? const Icon(Icons.arrow_forward_ios_rounded)
            : null,
      ),
    );
  }
}
