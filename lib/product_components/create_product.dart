import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowing_octo_lamp/product_components/read_all_products.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../helpers/validate.dart';
import '../models/api_model.dart';
import '../models/user_model.dart';

class CreateProductComponent extends StatefulWidget {
  const CreateProductComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<CreateProductComponent> createState() => _CreateProductComponentState();
}

class _CreateProductComponentState extends State<CreateProductComponent> {
  final _createProductFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _descriptionTextController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _priceTextController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _countTextController = TextEditingController();
  final _countFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  String _selectedtype = "Drink";

  Future<void> createProduct(String name, String description, double price,
      int count, String category) async {
    try {
      await http
          .post(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.port}/products/create'),
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
            _response = json.decode(response.body);
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GetAllProductsComponent(
                    user: _user,
                    jwt: _jwt,
                    socket: _socket,
                  )));
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response = json.decode(response.body);
          });
          throw Exception('Failed to create new user.');
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
  void initState() {
    super.initState();
    _user = widget.user;
    _jwt = widget.jwt;
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
                      key: _createProductFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Add Product'),
                          TextFormField(
                            autocorrect: false,
                            controller: _nameTextController,
                            focusNode: _nameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _descriptionTextController,
                            focusNode: _descriptionFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Description",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _priceTextController,
                            focusNode: _priceFocusNode,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]'))
                            ],
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Price (numbers only)",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _countTextController,
                            focusNode: _countFocusNode,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]'))
                            ],
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Count (numbers only)",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          DropdownButtonFormField(
                            value: _selectedtype,
                            items: dropdownItems,
                            focusNode: _categoryFocusNode,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Permission Level",
                              labelStyle: TextStyle(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedtype = value!;
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
                                            if (_createProductFormKey
                                                .currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              double priceDouble =
                                                  double.tryParse(
                                                          _priceTextController
                                                              .text) ??
                                                      0.0;
                                              await createProduct(
                                                  _nameTextController.text,
                                                  _descriptionTextController
                                                      .text,
                                                  priceDouble,
                                                  int.parse(_countTextController
                                                      .text),
                                                  _selectedtype);
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
                                _selectedtype = "Training";
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
