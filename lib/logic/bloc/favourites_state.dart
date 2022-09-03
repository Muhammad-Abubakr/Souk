part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  final List<Product> favourites;

  const FavouritesState(this.favourites);

  @override
  List<Object> get props => [favourites];
}

class FavouritesInitialState extends FavouritesState {
  const FavouritesInitialState() : super(const []);
}

class FavouritesUpdateState extends FavouritesState {
  const FavouritesUpdateState(List<Product> updatedState) : super(updatedState);
}
