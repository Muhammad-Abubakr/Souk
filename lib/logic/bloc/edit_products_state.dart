part of 'edit_products_bloc.dart';

// Base State
abstract class EditProductsState extends Equatable {
  final File? imageFile;

  const EditProductsState(File? image) : imageFile = image;

  @override
  List<Object> get props => [imageFile!];
}

// Initial State
class EditProductsStateInitial extends EditProductsState {
  const EditProductsStateInitial(File? image) : super(image);
}

// Update State
class EditProductsStateUpdate extends EditProductsState {
  const EditProductsStateUpdate(File? image) : super(image);
}
