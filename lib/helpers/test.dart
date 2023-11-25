import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/helpers/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/api_model.dart';
import '../models/user_model.dart';
import 'constants.dart';

class TestComponent extends StatefulWidget {
  const TestComponent({super.key, required this.jwt, required this.socket});
  final String jwt;
  final IO.Socket socket;

  @override
  State<TestComponent> createState() => _TestComponentState();
}

class _TestComponentState extends State<TestComponent> {
  late String _jwt;
  late IO.Socket _socket;
  bool _error = false;
  String _response = "";
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    super.initState();
    _jwt = widget.jwt;
    _socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ImagePickerComponent(
            onSelect: (value) {
              setState(() {
                _response = value!;
              });
            },
          ),
          Text(_response)
        ],
      ),
    );
  }
}
