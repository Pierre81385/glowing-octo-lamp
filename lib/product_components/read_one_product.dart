import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/product_components/read_all_products.dart';
import 'package:glowing_octo_lamp/product_components/update_product.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/api_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class GetProductComponent extends StatefulWidget {
  const GetProductComponent(
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
  State<GetProductComponent> createState() => _GetProductComponentState();
}

class _GetProductComponentState extends State<GetProductComponent> {
  late String _id;
  late Product _product;
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    getProductById(_id);
  }

  Future<void> getProductById(id) async {
    try {
      final resp = await api.getOne("products/$_id", _jwt, _socket);
      setState(() {
        _response = resp;
        _product = Product.fromJson(_response['product']);
        _error = false;
        _message = "Found a product!";
        _isProcessing = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
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
              : _error
                  ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            _message,
                          ),
                          Text(
                            _response.toString(),
                          ),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back'))
                        ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_outlined)),
                              ]),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('category: ${_product.category}'),
                                Text(_product.name),
                                Text(_product.description),
                                Text('\$${_product.price.toString()}'),
                                Text('qty: ${_product.count.toString()}'),
                              ],
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProductComponent(
                                          user: _user,
                                          product: _product,
                                          jwt: _jwt,
                                          socket: _socket,
                                        )));
                              },
                              child: const Text('Update'))
                        ],
                      ),
                    )),
    );
  }
}
