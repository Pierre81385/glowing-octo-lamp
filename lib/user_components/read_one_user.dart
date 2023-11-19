import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/update_user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/api_model.dart';
import '../models/user_model.dart';
import '../helpers/constants.dart';

class GetUserComponent extends StatefulWidget {
  const GetUserComponent(
      {super.key,
      required this.jwt,
      required this.user,
      required this.currentUser,
      required this.socket});
  final String jwt;
  final User user;
  final User currentUser;
  final IO.Socket socket;

  @override
  State<GetUserComponent> createState() => _GetUserComponentState();
}

class _GetUserComponentState extends State<GetUserComponent> {
  late String _jwt;
  late User _user;
  late User _currentUser;
  late IO.Socket _socket;
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    _jwt = widget.jwt;
    _user = widget.user;
    _currentUser = widget.currentUser;
    _socket = widget.socket;
    getUserById(_user.id);
    super.initState();
  }

  Future<void> getUserById(id) async {
    try {
      final resp = await api.getAll("users/$id", _jwt, _socket);
      setState(() {
        _response = resp;
        _user = User.fromJson(_response['user']);
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
                          Text(
                            _response.toString(),
                          ),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back'))
                        ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                      Icons.arrow_back_ios_new_outlined)),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('${_user.firstName} ${_user.lastName}'),
                                Text(_user.email),
                                Text('Permission level: ${_user.type}'),
                              ],
                            ),
                          ),
                          _user.type == "Limited" || _user.id != _currentUser.id
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
                    )),
    );
  }
}
