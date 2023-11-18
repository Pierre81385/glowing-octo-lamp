//display all products
//onClick add product.id to List<String> cart
//onCreate get current _user.id and cart and save to db
//order status is 'received'

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class CreateOrderComponent extends StatefulWidget {
  const CreateOrderComponent(
      {super.key, required this.user, required this.socket});
  final User user;
  final IO.Socket socket;

  @override
  State<CreateOrderComponent> createState() => _CreateOrderComponentState();
}

class _CreateOrderComponentState extends State<CreateOrderComponent> {
  late User _user;
  late IO.Socket _socket;
  late bool _loading;
  late bool _isProcessing;
  List<Product> _response = [];
  bool _error = false;
  String _message = "";

  Future<void> getAllProduct() async {
    try {
      await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/products/'),
        headers: {"Content-Type": "application/json"},
      ).then((response) {
        final parsed =
            (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response =
                parsed.map<Product>((json) => Product.fromJson(json)).toList();
          });
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response =
                parsed.map<Product>((json) => Product.fromJson(json)).toList();
          });
          throw Exception('Failed to get all products.');
        }
      });
    } on Exception catch (e) {
      setState(() {
        _isProcessing = false;
        _error = true;
        _message = e.toString();
      });
    }
  }

  void createOrder(String userId, List<String> orderedProduct) {}

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
