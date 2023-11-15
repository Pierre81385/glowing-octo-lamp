class Product {
  final String id;
  late String name;
  late String description;
  late double price;
  late int count;
  late String category;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.count,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> product) {
    return Product(
        id: product["_id"],
        name: product['name'],
        description: product["description"],
        price: product["price"].toDouble(),
        count: product["count"],
        category: product["category"]);
  }
}
