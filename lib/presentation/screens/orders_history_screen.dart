import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/orders_bloc.dart';
import '../widgets/main_drawer.dart';
import '../widgets/ordered_item_widget.dart';

class OrdersHistoryScreen extends StatefulWidget {
  static const routeName = '/orders-history';

  const OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryScreen> createState() => _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<OrdersHistoryScreen> {
  late bool expandAll = false;

  @override
  Widget build(BuildContext context) {
    final orders = context.select((OrdersBloc bloc) => bloc.state.orders);

    return Scaffold(
      // ? App Bar
      appBar: AppBar(
        elevation: 0,
        title: const Text('Orders'),
        actions: [
          IconButton(
            onPressed: () => setState(() => expandAll = !expandAll),
            icon: Icon(
              expandAll ? Icons.close_fullscreen_rounded : Icons.expand_rounded,
            ),
          ),

          // ? More Button (Filtering and Sorting)
          IconButton(
            onPressed: () => moreOptionsBottomSheet(context),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),

      // ? Main Drawer
      drawer: MainDrawer(parentContext: context),

      // ? Body
      body: orders.isEmpty
          ? Align(
              alignment: Alignment.center,
              child: Text(
                "Place some orders to show them here",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: orders
                  .map((order) => OrderDetails(orderID: order.id, expandAll: expandAll))
                  .toList(),
            ),
    );
  }

  Future<dynamic> moreOptionsBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      context: context,
      builder: (builderContext) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}
