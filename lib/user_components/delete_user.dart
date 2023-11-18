import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/api_model.dart';

class DeleteUserComponent extends StatefulWidget {
  const DeleteUserComponent(
      {super.key, required this.id, required this.jwt, required this.socket});
  final String id;
  final String jwt;
  final IO.Socket socket;

  @override
  State<DeleteUserComponent> createState() => _DeleteUserComponentState();
}

class _DeleteUserComponentState extends State<DeleteUserComponent> {
  late String _id;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    _id = widget.id;
    _jwt = widget.jwt;
    _socket = widget.socket;
    super.initState();
  }

  Future<void> deleteUser() async {
    try {
      await api.deleteOne("users/", _jwt, _id, _socket);
      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
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
        ? const CircularProgressIndicator()
        : !_error
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isProcessing = true;
                  });
                  deleteUser();
                },
                icon: const Icon(Icons.delete))
            : IconButton(
                onPressed: () {
                  AlertDialog(
                    title: const Text('ERROR'),
                    content: Column(
                      children: [
                        Text(_message),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.error));
  }
}
