part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  final List<Order> orders;

  const OrdersState(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrdersInitialState extends OrdersState {
  const OrdersInitialState(List<Order> initialState) : super(initialState);
}

class OrdersUpdateState extends OrdersState {
  const OrdersUpdateState(List<Order> updatedState) : super(updatedState);
}
