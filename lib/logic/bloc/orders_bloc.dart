import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import 'cart_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  // we will need some connection between cartBloc and ordersBloc
  final CartBloc _cartBloc;
  late List<CartItem> _cartItems;

  OrdersBloc(this._cartBloc) : super(const OrdersInitialState([])) {
    // initializing the cart items
    _cartItems = _cartBloc.state.cartProducts;
    // registering a streamsubscription to get updated items
    _cartBloc.stream.listen((cartState) {
      _cartItems = cartState.cartProducts;
    });

    // registering event handlers
    on<PlaceOrderEvent>(_placeOrderEventHandler);
  }

  FutureOr<void> _placeOrderEventHandler(PlaceOrderEvent event, Emitter<OrdersState> emit) {
    // create a new List from the old State
    // add the new order
    final List<Order> updatedState = [
      Order(
        id: _generateOrderID(),
        ordererdItems: List.from(_cartItems),
        dateTime: DateTime.now(),
      ),
      ...state.orders,
    ];

    // emit the new State
    emit(OrdersUpdateState(updatedState));
  }

  // helper functions
  String _generateOrderID() {
    // we will go with the hex system for the id
    return (state.orders.length + 1).toRadixString(16);
  }

  int findIdxByID(String orderID) {
    return state.orders.indexWhere((order) => order.id == orderID);
  }

  List<String> formatDateTime(DateTime dateTime) {
    String iso8601 = dateTime.toIso8601String();

    final iso8601Split = iso8601.split("T");
    final date = iso8601Split[0];
    final timeWithMacros = iso8601Split[1];

    final time = timeWithMacros.split(".")[0];

    return [date, time];
  }

  @override
  Future<void> close() {
    _cartBloc.close();
    return super.close();
  }
}
