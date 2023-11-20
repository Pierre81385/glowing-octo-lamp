import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import '../models/api_model.dart';

class DeleteOrderComponent extends StatefulWidget {
  const DeleteOrderComponent(
      {super.key, required this.id, required this.jwt, required this.socket});
  final String jwt;
  final String id;
  final IO.Socket socket;

  @override
  State<DeleteOrderComponent> createState() => _DeleteOrderComponentState();
}

class _DeleteOrderComponentState extends State<DeleteOrderComponent> {
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
    _jwt = widget.jwt;
    _id = widget.id;
    _socket = widget.socket;
    super.initState();
  }

  Future<void> deleteOrder() async {
    try {
      final resp = await api.deleteOne("orders/$_id", _jwt, _socket);
      setState(() {
        _isProcessing = false;
      });
      _socket.emit('order_deleted', resp);
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
        : _error
            ? IconButton(
                onPressed: () {
                  AlertDialog(
                    title: const Text('ERROR'),
                    content: Column(
                      children: [Text(_message), Text(_response.toString())],
                    ),
                  );
                },
                icon: const Icon(Icons.error))
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isProcessing = true;
                    _error = false;
                  });
                  deleteOrder();
                },
                icon: const Icon(Icons.delete));
  }
}
