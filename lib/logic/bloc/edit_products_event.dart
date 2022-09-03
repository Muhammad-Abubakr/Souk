part of 'edit_products_bloc.dart';

abstract class EditProductsEvent {}

// Select Image form gallery event
class SelectImageFromStorage extends EditProductsEvent {}

// Reset Product Image to initial state
class ResetImageToInital extends EditProductsEvent {}
