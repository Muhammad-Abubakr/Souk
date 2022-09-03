import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import 'products_bloc.dart';
import 'products_state.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  // we will need a communication channel between both bloc streams
  final ProductsBloc _productsBloc;
  late List<Product> _products;

  FavouritesBloc(ProductsBloc bloc)
      :
        // assigning the productsBloc the received bloc instance
        _productsBloc = bloc,
        // passing the initial state to the bloc
        super(const FavouritesInitialState()) {
    // registering a stream to ProductsBloc to listen the stream changes to get
    // updated Products, because if we don't have an updated Products List, there
    // might be cases we such a ProductID is passed through FavouritesEvents that
    // is not registered in our locally registered ProductsBloc state List.
    _products = _productsBloc.state.products;

    _productsBloc.stream.listen(_productsBlocChangeHandler);

    // registering event handlers
    on<ToggleFavouriteEvent>(_toggleFavouriteEventHandler);
    on<AddFavouriteEvent>(_addFavouriteEventHandler);
    on<RemoveFavouriteEvent>(_removeFavouriteEventHandler);

    // ? Private Event Handlers
    on<_PeriodicStateTest>(
      (event, emit) => emit(
        FavouritesUpdateState(event.updatedState),
      ),
    );
  }

  FutureOr<void> _toggleFavouriteEventHandler(
      ToggleFavouriteEvent event, Emitter<FavouritesState> emit) {
    // so what do we need to do to act as the toggle for favourites using the array
    // ? =>> check the favourites
    //     ? => if in there pull it out
    //     ? => if not put it in
    int favouriteIndex = _isInFavourites(event.productId);

    // ? =>> create a new array of favourites
    List<Product> updatedFavourites = [...state.favourites];

    if (favouriteIndex > -1) {
      updatedFavourites.removeAt(favouriteIndex);
    } else {
      updatedFavourites.add(Product.copyWith(_getProduct(event.productId)));
    }

    // ? and emit the state
    emit(FavouritesUpdateState(updatedFavourites));
  }

  FutureOr<void> _addFavouriteEventHandler(
      AddFavouriteEvent event, Emitter<FavouritesState> emit) {}

  FutureOr<void> _removeFavouriteEventHandler(
      RemoveFavouriteEvent event, Emitter<FavouritesState> emit) {}

  // helper functions
  int _isInFavourites(String productID) {
    return state.favourites.indexWhere((element) => element.id == productID);
  }

  // get the product from the products
  Product _getProduct(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  // exposing an API call to the state to check if there is a product in favourites
  // or not
  bool contains(String productID) {
    return state.favourites.indexWhere((element) => element.id == productID) > -1;
  }

  @override
  Future<void> close() {
    _productsBloc.close();
    return super.close();
  }

  @override
  void onEvent(FavouritesEvent event) {
    super.onEvent(event);

    if (kDebugMode) {
      print("Event => $event");
    }
  }

  // Called whenever there is a change in Products Bloc
  void _productsBlocChangeHandler(ProductsState productState) {
    // update Products state
    _products = productState.products;

    // check if any of the wishlisted items is no more in the _products
    for (Product item in state.favourites) {
      // if not present update the wishlisted state
      if (!_products.contains(item)) {
        // create a new List
        List<Product> updatedFavourites = [...state.favourites]..remove(item);

        // add the private event _PeriodicStateTest
        add(_PeriodicStateTest(updatedState: updatedFavourites));
      }
    }
  }
}
