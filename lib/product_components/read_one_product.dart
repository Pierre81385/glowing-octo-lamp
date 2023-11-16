import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/product_components/read_all_products.dart';
import 'package:glowing_octo_lamp/product_components/update_product.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ProductDetailComponent extends StatefulWidget {
  const ProductDetailComponent(
      {super.key,
      required this.id,
      required this.user,
      required this.jwt,
      required this.socket});
  final String id;
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<ProductDetailComponent> createState() => _ProductDetailComponentState();
}

class _ProductDetailComponentState extends State<ProductDetailComponent> {
  late String _id;
  late Product _product;
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _socket = widget.socket;
    getProductById(_id);
  }

  Future<void> getProductById(String id) async {
    try {
      await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/products/$id'),
        headers: {"Content-Type": "application/json"},
      ).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response = json.decode(response.body);
            _product = Product.fromJson(_response);
          });
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response = json.decode(response.body);
          });
          throw Exception('Failed to get product.');
        }
      });
    } on Exception catch (e) {
      setState(() {
        _user = widget.user;
        _jwt = widget.jwt;
        _isProcessing = false;
        _error = true;
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isProcessing
            ? Column(
                children: [
                  const CircularProgressIndicator(),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GetAllProductsComponent(
                                  user: _user,
                                  jwt: _jwt,
                                  socket: _socket,
                                )));
                      },
                      child: const Text('Back'))
                ],
              )
            : !_error
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('category: ${_product.category}'),
                            Text(_product.name),
                            Text(_product.description),
                            Text('\$${_product.price.toString()}'),
                            Text('qty: ${_product.count.toString()}'),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Back')),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateProductComponent(
                                            product: _product,
                                            socket: _socket,
                                          )));
                                },
                                child: const Text('Update'))
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          _message,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _response.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'))
                      ],
                    ),
                  ),
      ),
    );
  }
}
