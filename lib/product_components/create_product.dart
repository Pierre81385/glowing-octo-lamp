import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowing_octo_lamp/product_components/read_all_products.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../helpers/validate.dart';
import '../models/api_model.dart';
import '../models/product_model.dart';
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
  final _categoryFocusNode = FocusNode();
  late User _user;
  late Product _product;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  String _selectedtype = "Drink";
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  Future<void> createProduct(product) async {
    try {
      final resp =
          await api.createWithAUth('products/create', product, _jwt, _socket);
      setState(() {
        _error = false;
        _isProcessing = false;
        _response = resp;
        _message = resp["message"];
        _product = Product.fromJson(resp["product"]);
      });
      success();
    } catch (e) {
      setState(() {
        _error = true;
        _isProcessing = false;
        _message = e.toString();
      });
    }
  }

  void success() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GetAllProductsComponent(
              user: _user,
              jwt: _jwt,
              socket: _socket,
            )));
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
    _socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: _error
          ? SizedBox(
              width: double.infinity,
              child: Column(
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
                        setState(() {
                          _error = false;
                          _nameTextController.text = "";
                          _descriptionTextController.text = "";
                          _priceTextController.text = "";
                          _selectedtype = "Training";
                          _response = {};
                        });
                      },
                      child: const Text('Ok'))
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                _nameFocusNode.unfocus();
                _descriptionFocusNode.unfocus();
                _priceFocusNode.unfocus();
                _categoryFocusNode.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _createProductFormKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined)),
                          ),
                        ],
                      ),
                      Expanded(
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
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
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
                          ],
                        ),
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
                                    _categoryFocusNode.unfocus();
                                    double priceDouble = double.tryParse(
                                            _priceTextController.text) ??
                                        0.0;

                                    if (_createProductFormKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        _isProcessing = true;
                                      });
                                      await createProduct({
                                        "name": _nameTextController.text,
                                        "description":
                                            _descriptionTextController.text,
                                        "price": priceDouble,
                                        "count": 0,
                                        "category": _selectedtype
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    ));
  }
}
