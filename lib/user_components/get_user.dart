import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/constants.dart';
import 'package:glowing_octo_lamp/user_components/update_user.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/user_model.dart';
import 'user_menu.dart';

class GetUserComponent extends StatefulWidget {
  const GetUserComponent(
      {super.key, required this.jwt, required this.user, required this.socket});
  final String jwt;
  final User user;
  final IO.Socket socket;

  @override
  State<GetUserComponent> createState() => _GetUserComponentState();
}

class _GetUserComponentState extends State<GetUserComponent> {
  late String _jwt;
  late User _user;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    _jwt = widget.jwt;
    _user = widget.user;
    _socket = widget.socket;
    getUserById(_user.id, _jwt);
    super.initState();
  }

  Future<void> getUserById(String id, String token) async {
    try {
      await http.get(
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
            _user = User.fromJson(json.decode(response.body));
          });
          throw Exception('Failed to get new user.');
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
            ? Column(
                children: [
                  const CircularProgressIndicator(),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'))
                ],
              )
            : !_error
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('${_user.firstName} ${_user.lastName}'),
                            Text(_user.email),
                            Text('Permission level: ${_user.type}'),
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
                            _user.type == "Limited"
                                ? const SizedBox()
                                : OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateUserComponent(
                                                    user: _user,
                                                    jwt: _jwt,
                                                    socket: _socket,
                                                  )));
                                    },
                                    child: const Text('Update'))
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          _message,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _response.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'))
                      ],
                    ),
                  ),
      ),
    );
  }
}
