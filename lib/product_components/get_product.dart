import 'package:flutter/material.dart';

class ProductDetailComponent extends StatefulWidget {
  const ProductDetailComponent({super.key, required this.id});
  final String id;

  @override
  State<ProductDetailComponent> createState() => _ProductDetailComponentState();
}

class _ProductDetailComponentState extends State<ProductDetailComponent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
