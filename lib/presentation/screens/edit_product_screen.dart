import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/edit_products_bloc.dart';
import '../../logic/bloc/products_bloc.dart';
import '../../logic/bloc/products_events.dart';
import '../../logic/models/product.dart';

// Defining an enum to tell this class to which state it needs to be loaded
enum EditProductScreenState { update, add }

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool init = false;
  // route args
  late final Map<String, Object> routeArgs;
  // loading state
  late final EditProductScreenState loadingState;

  // ? isLoadingState Update?
  late final bool isUpdate;

  // if is Update
  late final String productID;
  late Product product;

  // * defining the focusNodes for the form
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _selectImageFocusNode = FocusNode();

  // * Form Global Key
  final _form = GlobalKey<FormState>();

  // ! state bloc
  late EditProductsBloc editProductsBloc;
  late ProductsBloc productsBloc;

  @override
  void dispose() {
    // Must Dispose focus nodes
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _selectImageFocusNode.dispose();
    super.dispose();
  }

  // getting the routeArgs
  @override
  void didChangeDependencies() {
    productsBloc = context.read<ProductsBloc>();

    //  if already initialized
    if (init) return;

    // otherwise
    init = true;

    // getting the routeArgs
    routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    // loading state
    loadingState = routeArgs['loadState'] as EditProductScreenState;
    isUpdate = loadingState == EditProductScreenState.update;

    if (isUpdate) {
      // getting the product id from route arguments
      productID = routeArgs['productID'] as String;
      // getting the Products from Products Bloc
      product = productsBloc.findByID(productID);
    } else {
      // If we are adding a new Product
      product = const Product.empty();
    }

    super.didChangeDependencies();
  }

  // ? Saving the form
  void _saveForm() {
    // TODO: add validation
    _form.currentState!.save();
    if (editProductsBloc.state.imageFile != null) {
      product = product.copyWith(image: editProductsBloc.state.imageFile!);
    }
    if (isUpdate) {
      productsBloc.add(UpdateProductEvent(product: product));
    } else {
      productsBloc.add(AddProductEvent(product: product));
      _form.currentState!.reset();
      editProductsBloc.add(ResetImageToInital());
    }

    // May change this later but for now its good enough
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // orientation
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // ? Returning Widget
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(isUpdate ? "Edit ${product.title}" : "Add Product"),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      // ? Form
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (isPortrait ? 0.05 : 0.2),
          vertical: MediaQuery.of(context).size.shortestSide * 0.05,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          // ? ------- Image select button || Image Preview Container ------- //
          Builder(builder: (context) {
            // ? edit products Bloc initialization
            editProductsBloc = context.watch<EditProductsBloc>();
            // ? image preview
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.shortestSide * 0.8,
                  height: MediaQuery.of(context).size.shortestSide * 0.8,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: // ? Image Pick Button
                      /// if the load_state is `add` and XFile imageFile is null
                      /// in EditProductsBloc otherwise show the image preview
                      /// whichever it is whether XFile or Url is load_state==update
                      !isUpdate && editProductsBloc.state.imageFile == null
                          ? TextButton.icon(
                              onPressed: () => editProductsBloc.add(SelectImageFromStorage()),
                              icon: const Icon(Icons.image_rounded),
                              label: const Text('Select an image'),
                              focusNode: _selectImageFocusNode,
                            )

                          // ? Image Preview
                          : Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image(
                                image: editProductsBloc.state.imageFile != null
                                    ? Image.file(
                                        editProductsBloc.state.imageFile!,
                                      ).image
                                    : product.image == null
                                        ? Image.network(product.imageUrl).image
                                        : Image.file(
                                            product.image!,
                                          ).image,
                                height: 400,
                              ),
                            ),
                ),
                const SizedBox(height: 8),

                // ? Reset Button
                if (editProductsBloc.state.imageFile != null)
                  TextButton.icon(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red.shade300),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (builderContext) => AlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("Image will be returned to its intial state."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("confirm"),
                          )
                        ],
                      ),
                    ).then((result) {
                      if (result != null && result) {
                        editProductsBloc.add(ResetImageToInital());
                      }
                    }),
                    icon: const Icon(Icons.fast_rewind_rounded),
                    label: const Text('reset image'),
                  ),

                // ? Pick a new image
                if (isUpdate &&
                    editProductsBloc.state.imageFile == null &&
                    ((product.image != null && product.imageUrl.isEmpty) ||
                        (product.image == null && product.imageUrl.isNotEmpty)))
                  TextButton.icon(
                    onPressed: () => editProductsBloc.add(SelectImageFromStorage()),
                    icon: const Icon(Icons.image_rounded),
                    label: const Text("Select a new image"),
                  ),

                // ? Aspect Ratio Recommended Text
                Text(
                  'Recommended: Picture with 1:1 aspect ratio',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey.shade400,
                      ),
                ),
              ],
            );
          }),
          const Divider(),
          // ? ---------------- Image Preview / Selector End ----------------- //
          const SizedBox(height: 32),

          // ? ----------------------- Form Starts -------------------------- //
          Form(
            key: _form,
            child: Column(
              children: [
                // ? Title Field
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title_rounded),
                    labelText: 'Title',
                  ),
                  initialValue: isUpdate ? product.title : '',
                  maxLength: 32,
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  onSaved: (value) => product = product.copyWith(title: value),
                ),
                const SizedBox(height: 16),

                // ? Price field
                TextFormField(
                  initialValue: isUpdate ? "${product.price}" : '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.price_change_rounded),
                    labelText: 'Price',
                    prefixText: '\$',
                  ),
                  maxLength: 12,
                  autocorrect: true,
                  enableSuggestions: true,
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_descriptionFocusNode),
                  onSaved: (value) => product = product.copyWith(price: double.parse(value!)),
                ),
                const SizedBox(height: 16),

                // ? Description field
                TextFormField(
                  initialValue: isUpdate ? product.description : '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description_rounded),
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 1000,
                  maxLines: 8,
                  minLines: null,
                  enableInteractiveSelection: true,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_selectImageFocusNode),
                  onSaved: (value) => product = product.copyWith(description: value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
