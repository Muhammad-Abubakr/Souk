part of 'orders_bloc.dart';

// Defining events that can be passed from the UI layer to the BL layer
abstract class OrdersEvent {}

// Place Order Event
class PlaceOrderEvent extends OrdersEvent {}
