import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Order with EquatableMixin {
  // Order compromises of the following attributes
  final String id;
  final List<CartItem> ordererdItems;
  final DateTime dateTime;
  late final double totalPrice;

  // ? Default Constructor
  Order({
    required this.id,
    required this.ordererdItems,
    required this.dateTime,
  }) {
    totalPrice = _getTotal();
  }

  // copyWith Constructor
  Order copyWith({
    List<CartItem>? ordererdItems,
    DateTime? dateTime,
  }) {
    return Order(
      id: id,
      ordererdItems: ordererdItems ?? this.ordererdItems,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  // utility function
  double _getTotal() {
    return ordererdItems.fold(0,
        (previousValue, element) => previousValue + element.product.price * element.quantity);
  }

  @override
  List<Object?> get props => [id, ordererdItems, dateTime, totalPrice];
}
