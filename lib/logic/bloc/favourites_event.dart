part of 'favourites_bloc.dart';

// Defining the events that can occur during the state change
abstract class FavouritesEvent {}

// Adding the Favourite Product Event
class AddFavouriteEvent extends FavouritesEvent {
  final String productId;

  AddFavouriteEvent(this.productId);
}

// Remove the Favourite Product Event
class RemoveFavouriteEvent extends FavouritesEvent {
  final String productId;

  RemoveFavouriteEvent(this.productId);
}

// Toggle Favourite Product Event
class ToggleFavouriteEvent extends FavouritesEvent {
  final String productId;

  ToggleFavouriteEvent(this.productId);
}

// ? Private events
// Periodic State Test Event
class _PeriodicStateTest extends FavouritesEvent {
  final List<Product> updatedState;

  _PeriodicStateTest({required this.updatedState});
}
