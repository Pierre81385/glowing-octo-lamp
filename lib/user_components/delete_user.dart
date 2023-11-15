import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  @override
  void initState() {
    _id = widget.id;
    _jwt = widget.jwt;
    _socket = widget.socket;
    super.initState();
  }

  Future<void> getUserByIdandDelete(String id, String token) async {
    try {
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/users/$id'),
        headers: {"Authorization": token, "Content-Type": "application/json"},
      ).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response = json.decode(response.body);
          });
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response = json.decode(response.body);
          });
          throw Exception('Failed to delete user.');
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
                        const Text('This user cannot be deleted at this time.'),
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
                  getUserByIdandDelete(_id, _jwt);
                },
                icon: const Icon(Icons.delete));
  }
}
