import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/orders_bloc.dart';
import '../../logic/models/order.dart';

class OrderDetails extends StatefulWidget {
  final String orderID;
  final bool expandAll;

  const OrderDetails({Key? key, required this.orderID, required this.expandAll})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // state for extended container for details
  late bool extendDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    extendDetails = widget.expandAll;
  }

  @override
  void didUpdateWidget(covariant OrderDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expandAll != widget.expandAll) {
      setState(() => extendDetails = widget.expandAll);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrdersBloc ordersBloc = context.read<OrdersBloc>();
    final Order order = ordersBloc.state.orders[ordersBloc.findIdxByID(widget.orderID)];
    final formattedOrderDateTime = ordersBloc.formatDateTime(order.dateTime);

    return Column(
      children: [
        // ? Summarized ListTile
        ListTile(
          tileColor: extendDetails ? Colors.grey.shade300 : null,
          onTap: () => setState(() => extendDetails = !extendDetails),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            child: Text(order.id),
          ),
          title: Text("Expenditure:  \$${order.totalPrice.toStringAsFixed(2)}"),
          subtitle:
              Text("Ordered on ${formattedOrderDateTime[0]} at ${formattedOrderDateTime[1]}"),
          trailing: Icon(extendDetails
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded),
        ),

        // ? Extended Section
        if (extendDetails) _buildOrderedItemsList(order, context),

        // ? Divider
        const Divider(),
      ],
    );
  }

  Container _buildOrderedItemsList(Order order, BuildContext context) {
    return Container(
      height: order.ordererdItems.length * (MediaQuery.of(context).size.height * 0.1),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.grey.shade200,
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => _buildOrderedItem(context, order, index),
        itemCount: order.ordererdItems.length,
      ),
    );
  }

  Column _buildOrderedItem(BuildContext context, Order order, int index) {
    final currentProduct = order.ordererdItems[index].product;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: Image(
              image: currentProduct.image != null
                  ? Image.file(currentProduct.image!).image
                  : Image.network(currentProduct.imageUrl).image,
              fit: BoxFit.contain,
            ).image,
            backgroundColor: Theme.of(context).canvasColor,
            radius: 24,
          ),
          title: Text(currentProduct.title),
          subtitle: Text("\$${currentProduct.price}"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Quantity: ${order.ordererdItems[index].quantity}",
                style:
                    Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black54),
              ),
              Text(
                "Total: \$${(order.ordererdItems[index].quantity * currentProduct.price).toStringAsFixed(2)}",
                style:
                    Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).canvasColor,
          thickness: 1.5,
        ),
      ],
    );
  }
}
