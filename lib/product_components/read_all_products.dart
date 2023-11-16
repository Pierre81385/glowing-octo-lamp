import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/product_components/create_product.dart';
import 'package:glowing_octo_lamp/product_components/delete_product.dart';
import 'package:glowing_octo_lamp/product_components/read_one_product.dart';
import 'package:glowing_octo_lamp/user_components/user_menu.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class GetAllProductsComponent extends StatefulWidget {
  const GetAllProductsComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<GetAllProductsComponent> createState() =>
      _GetAllProductsComponentState();
}

class _GetAllProductsComponentState extends State<GetAllProductsComponent> {
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  List<Product> _response = [];

  @override
  void initState() {
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    _socket.on("update_product_list", (data) {
      getAllProduct();
    });
    getAllProduct();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isProcessing
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back')),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateProductComponent(
                                        user: _user,
                                        jwt: _jwt,
                                        socket: _socket,
                                      )));
                            },
                            child: const Text('Add Product processing')),
                      ],
                    )
                  ],
                ),
              )
            : !_error
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserMenuComponent(
                                            user: _user,
                                            jwt: _jwt,
                                            socket: _socket,
                                          )));
                                },
                                child: const Text('Back')),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CreateProductComponent(
                                            user: _user,
                                            jwt: _jwt,
                                            socket: _socket,
                                          )));
                                },
                                child: const Text('Add Product')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _response.length,
                            itemBuilder: (BuildContext context, int index) {
                              Product product = _response[index];
                              return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailComponent(
                                                  id: product.id,
                                                  user: _user,
                                                  jwt: _jwt,
                                                  socket: _socket,
                                                )));
                                  },
                                  isThreeLine: true,
                                  leading:
                                      Text('qty: ${product.count.toString()}'),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(product.name),
                                      Text('\$${product.price.toString()}')
                                    ],
                                  ),
                                  subtitle: Text(product.description),
                                  trailing: DeleteProductComponent(
                                    id: product.id,
                                    user: _user,
                                    jwt: _jwt,
                                    socket: _socket,
                                  ) //delete component here,
                                  );
                            }),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        _message,
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        _response.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserMenuComponent(
                                      user: _user,
                                      jwt: _jwt,
                                      socket: _socket,
                                    )));
                          },
                          child: const Text('Back')),
                    ],
                  ),
      ),
    );
  }
}
