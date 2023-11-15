import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants.dart';
import '../models/product_model.dart';
import '../validate.dart';

class UpdateProductComponent extends StatefulWidget {
  const UpdateProductComponent(
      {super.key, required this.product, required this.socket});
  final Product product;
  final IO.Socket socket;

  @override
  State<UpdateProductComponent> createState() => _UpdateProductComponentState();
}

class _UpdateProductComponentState extends State<UpdateProductComponent> {
  final _updateProductFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _descriptionTextController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _priceTextController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _countTextController = TextEditingController();
  final _countFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  late Product _product;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _socket = widget.socket;
  }

  Future<void> UpdateProduct(String name, String description, double price,
      int count, String category, String id) async {
    try {
      await http
          .put(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.port}/products/$id'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                'name': name,
                'description': description,
                'price': price,
                'count': count,
                'category': category
              }))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
          });

          Navigator.of(context).pop();
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
          });
          throw Exception('Failed to update product.');
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Drink",
          child: Text(
            "Drink",
            style: TextStyle(color: Colors.black),
          )),
      const DropdownMenuItem(
          value: "App",
          child: Text(
            "App",
            style: TextStyle(color: Colors.black),
          )),
      const DropdownMenuItem(
        value: "Main",
        child: Text(
          "Main",
          style: TextStyle(color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
          value: "Dessert",
          child: Text(
            "Dessert",
            style: TextStyle(color: Colors.black),
          )),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: !_error
              ? GestureDetector(
                  onTap: () {
                    _nameFocusNode.unfocus();
                    _descriptionFocusNode.unfocus();
                    _priceFocusNode.unfocus();
                    _countFocusNode.unfocus();
                    _categoryFocusNode.unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _updateProductFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Update Product'),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _product.name,
                            //controller: _nameTextController,
                            focusNode: _nameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _product.name = value;
                              });
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _product.description,
                            //controller: _descriptionTextController,
                            focusNode: _descriptionFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            onChanged: (value) {
                              _product.description = value;
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Description",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _product.price.toString(),
                            //controller: _priceTextController,
                            focusNode: _priceFocusNode,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]'))
                            ],
                            onChanged: (value) {
                              _product.price = double.tryParse(value) ?? 0.0;
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Price (numbers only)",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _product.count.toString(),
                            //controller: _countTextController,
                            focusNode: _countFocusNode,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]'))
                            ],
                            onChanged: (value) {
                              setState(() {
                                _product.count = int.parse(value);
                              });
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Count (numbers only)",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          DropdownButtonFormField(
                            value: _product.category,
                            items: dropdownItems,
                            focusNode: _categoryFocusNode,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Permission Level",
                              labelStyle: TextStyle(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _product.category = value!;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                              _isProcessing
                                  ? const CircularProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            _nameFocusNode.unfocus();
                                            _descriptionFocusNode.unfocus();
                                            _priceFocusNode.unfocus();
                                            _countFocusNode.unfocus();
                                            _categoryFocusNode.unfocus();
                                            if (_updateProductFormKey
                                                .currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });

                                              await UpdateProduct(
                                                  _product.name,
                                                  _product.description,
                                                  _product.price,
                                                  _product.count,
                                                  _product.category,
                                                  _product.id);
                                            }
                                          },
                                          child: const Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : !_error
                  ? Column(
                      children: [
                        Text(_response.toString()),
                        const Text('SUCCESS'),
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _error = false;
                                _nameTextController.text = "";
                                _descriptionTextController.text = "";
                                _priceTextController.text = "";
                                _countTextController.text = "";
                                _response = {};
                              });
                            },
                            child: const Text('Ok'))
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          _message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          _response.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'))
                      ],
                    )),
    );
  }
}
