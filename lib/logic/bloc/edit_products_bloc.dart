import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_products_event.dart';
part 'edit_products_state.dart';

class EditProductsBloc extends Bloc<EditProductsEvent, EditProductsState> {
  EditProductsBloc() : super(const EditProductsStateInitial(null)) {
    // event handlers
    on<SelectImageFromStorage>(_selectImageFromStorageHandler);
    on<ResetImageToInital>(_resetImageToInitialHandler);
  }

  // Select image from storage handler
  FutureOr<void> _selectImageFromStorageHandler(
      SelectImageFromStorage event, Emitter<EditProductsState> emit) async {
    // Create image picker instance
    final imagePicker = ImagePicker();

    // provoke imagePicker.pickImage() with source being gallery
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    // convert the image to File before saving to the state
    // ! if not null otherwise do not update state
    // and emit updated State with value
    if (image != null) {
      emit(EditProductsStateUpdate(File(image.path)));
    }
  }

  FutureOr<void> _resetImageToInitialHandler(
      ResetImageToInital event, Emitter<EditProductsState> emit) {
    emit(const EditProductsStateInitial(null));
  }
}
