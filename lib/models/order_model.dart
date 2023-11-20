//orders are unique, so id required
//orders are taken by someone, so user.id required
//orders have orderItems

import 'product_model.dart';

class Order {
  final String id;
  late String placedBy;
  late List<Product> orderItems;
  late String orderNumber;
  late String orderStatus;

  Order(
      {required this.id,
      required this.placedBy,
      required this.orderItems,
      required this.orderNumber,
      required this.orderStatus});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placedBy': placedBy,
      'orderItems': orderItems,
      'orderNumber': orderNumber,
      'orderStatus': orderStatus
    };
  }

  factory Order.fromJson(Map<String, dynamic> order) {
    return Order(
        id: order['_id'],
        placedBy: order['placedBy'],
        orderItems: order['orderItems']
            .map((product) => Product.fromJson(product))
            .toList(),
        orderNumber: order['orderNumber'],
        orderStatus: order['orderStatus']);
  }
}
