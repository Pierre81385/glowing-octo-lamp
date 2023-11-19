import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/read_one_user.dart';
import '../models/user_model.dart';
import './delete_user.dart';
import '../helpers/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/api_model.dart';

class GetAllUsersComponent extends StatefulWidget {
  const GetAllUsersComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<GetAllUsersComponent> createState() => _GetAllUsersComponentState();
}

class _GetAllUsersComponentState extends State<GetAllUsersComponent> {
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _update = false;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  List<User> _response = [];
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    _socket.on("update_users_list", (data) {
      getAllUsers();
    });
    getAllUsers();
    super.initState();
  }

  Future<void> getAllUsers() async {
    try {
      final resp = await api.getAll("users/", _jwt, _socket);
      final parsed = (resp['users'] as List).cast<Map<String, dynamic>>();
      final map = parsed.map<User>((json) => User.fromJson(json)).toList();
      setState(() {
        _response = map;
        _error = false;
        _message = "Found users!";
        _isProcessing = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
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
            : _error
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          _message,
                        ),
                        Text(_response.toString()),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'))
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back')),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _response.length,
                            itemBuilder: (BuildContext context, int index) {
                              User user = _response[index];
                              return user.id == _user.id
                                  ? const SizedBox()
                                  : ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GetUserComponent(
                                                      jwt: _jwt,
                                                      user: user,
                                                      socket: _socket,
                                                    )));
                                      },
                                      isThreeLine: true,
                                      title: Text(
                                          '${user.firstName} ${user.lastName}'),
                                      subtitle: Text(user.type),
                                      trailing: DeleteUserComponent(
                                        id: user.id,
                                        jwt: _jwt,
                                        socket: _socket,
                                      ),
                                    );
                            }),
                      ),
                    ],
                  ),
      ),
    );
  }
}
