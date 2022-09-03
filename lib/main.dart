/*
  Created as a state-shop package, to learn about state management
  Later renamed to Souk for the application identity.
*/

/// imports
/// Package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

///  Local imports
import 'app.dart';
// firebase imports
import 'firebase_options.dart';
import 'logic/bloc/authentication_bloc.dart';
import 'logic/bloc/cart_bloc.dart';
import 'logic/bloc/edit_products_bloc.dart';
import 'logic/bloc/favourites_bloc.dart';
import 'logic/bloc/orders_bloc.dart';
import 'logic/bloc/products_bloc.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/edit_product_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/manage_products_screen.dart';
import 'presentation/screens/orders_history_screen.dart';
import 'presentation/screens/product_details_screen.dart';
import 'presentation/screens/settings_screen.dart';

///  [Main] entry point [runApp]
void main() async {
  // Since we are initializing our firebase application
  // before calling runApp() we must ensure our flutter
  // bindings have been initialized first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the firebase application
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initializing flutter app
  runApp(const Main());
}

/// Main stateless widget, returns [MaterialApp], containing
/// [ThemeData], Applications top-level [RouteTable]
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// Wrapping the [MaterialApp] with [MultiBlocProvider] that takes two
    /// arguments `providers` that takes an array of BlocProviders that we want to pass
    /// and a `child` argument which acts as a descendent of the [MultiBlocProvider]
    ///  we wrapped around
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => ProductsBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (buildContext) => CartBloc(buildContext.read<ProductsBloc>()),
        ),
        BlocProvider<FavouritesBloc>(
          create: (buildContext) => FavouritesBloc(buildContext.read<ProductsBloc>()),
        ),
        BlocProvider<OrdersBloc>(
          create: (buildContext) => OrdersBloc(buildContext.read<CartBloc>()),
        ),
      ],
      child: MaterialApp(
        title: 'Souk',

        /// [ThemeData] contains configuration globally available in the application
        theme: ThemeData(
          primarySwatch: Colors.teal,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
            secondary: Colors.white,
          ),
          textTheme: GoogleFonts.robotoTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: ColorScheme.fromSwatch(primarySwatch: Colors.teal).primary,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: ColorScheme.fromSwatch(primarySwatch: Colors.red).primary,
              ),
            ),
          ),
        ),

        /// Applications top-level [RouteTable] and initialRoute, the first screen
        /// displayed
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          App.routeName: (_) => const App(),
          ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
          OrdersHistoryScreen.routeName: (_) => const OrdersHistoryScreen(),
          ManageProductsScreen.routeName: (_) => const ManageProductsScreen(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          EditProductScreen.routeName: (_) => BlocProvider<EditProductsBloc>(
                create: (context) => EditProductsBloc(),
                child: const EditProductScreen(),
              ),
        },
      ),
    );
  }
}
