import 'dart:convert';
import 'package:glowing_octo_lamp/product_components/get_all_products.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user_model.dart';

class DeleteProductComponent extends StatefulWidget {
  const DeleteProductComponent(
      {super.key, required this.id, required this.user, required this.jwt});
  final User user;
  final String jwt;
  final String id;

  @override
  State<DeleteProductComponent> createState() => _DeleteProductComponentState();
}

class _DeleteProductComponentState extends State<DeleteProductComponent> {
  late String _id;
  late User _user;
  late String _jwt;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    _user = widget.user;
    _jwt = widget.jwt;
    _id = widget.id;
    super.initState();
  }

  Future<void> getProductByIdandDelete(String id) async {
    try {
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/Products/$id'),
        headers: {"Content-Type": "application/json"},
      ).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response = json.decode(response.body);
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GetAllProductsComponent(
                    user: _user,
                    jwt: _jwt,
                  )));
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response = json.decode(response.body);
          });
          throw Exception('Failed to delete Product.');
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
    return _isProcessing
        ? CircularProgressIndicator()
        : _error
            ? IconButton(
                onPressed: () {
                  AlertDialog(
                    title: const Text('ERROR'),
                    content: Column(
                      children: [
                        const Text(
                            'This Product cannot be deleted at this time.'),
                        Text(_message),
                        Text(_response.toString())
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.error))
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isProcessing = true;
                  });
                  getProductByIdandDelete(_id);
                },
                icon: const Icon(Icons.delete));
  }
}
