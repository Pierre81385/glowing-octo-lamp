//orders are unique, so id required
//orders are taken by someone, so user.id required
//orders have orderItems

class Order {
  final String id;
  late String placedBy;
  late List<String> orderItems;
  late String orderNumber;
  late String orderStatus;

  Order(
      {required this.id,
      required this.placedBy,
      required this.orderItems,
      required this.orderNumber,
      required this.orderStatus});

  factory Order.fromJson(Map<String, dynamic> order) {
    return Order(
        id: order['_id'],
        placedBy: order['placedBy'],
        orderItems: [order['orderItems']],
        orderNumber: order['orderNumber'],
        orderStatus: order['orderStatus']);
  }
}
