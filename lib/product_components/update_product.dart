import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowing_octo_lamp/product_components/read_one_product.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/api_model.dart';
import '../models/product_model.dart';
import '../helpers/constants.dart';
import '../helpers/validate.dart';
import '../models/user_model.dart';

class UpdateProductComponent extends StatefulWidget {
  const UpdateProductComponent(
      {super.key,
      required this.user,
      required this.product,
      required this.jwt,
      required this.socket});
  final User user;
  final Product product;
  final String jwt;
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
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  late User _user;
  late Product _product;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _product = widget.product;
    _jwt = widget.jwt;
    _socket = widget.socket;
  }

  Future<void> updateOneProduct(
    Product product,
  ) async {
    try {
      final resp =
          await api.update('products', _jwt, product.toJson(), _socket);
      setState(() {
        _isProcessing = false;
      });
      _socket.emit('product_update_successful', resp);
      updateSuccess();
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
      });
    }
  }

  void updateSuccess() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GetProductComponent(
              id: _product.id,
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
                      ),
                      Text(
                        _response.toString(),
                      ),
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
                          child: const Text('Back'))
                    ],
                  ),
                )
              : GestureDetector(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
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
                                              await updateOneProduct(_product);
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
                )),
    );
  }
}
