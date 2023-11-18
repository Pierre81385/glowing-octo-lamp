import 'package:flutter/material.dart';
import '../models/user_model.dart';
import './delete_user.dart';
import '../helpers/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/api_model.dart';

class GetAllUsersComponent extends StatefulWidget {
  const GetAllUsersComponent(
      {super.key, required this.jwt, required this.id, required this.socket});
  final String jwt;
  final String id;
  final IO.Socket socket;

  @override
  State<GetAllUsersComponent> createState() => _GetAllUsersComponentState();
}

class _GetAllUsersComponentState extends State<GetAllUsersComponent> {
  late String _jwt;
  late String _id;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  List<User> _response = [];
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  Future<void> getAllUsers() async {
    try {
      final resp = await api.getAll("users/", _jwt, _socket);
      setState(() {
        _response = resp.map<User>((json) => User.fromJson(json)).toList();
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    _jwt = widget.jwt;
    _id = widget.id;
    _socket = widget.socket;
    _socket.on("update_users_list", (data) {
      getAllUsers();
    });
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : !_error
                ? Column(
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
                              return user.id == _id
                                  ? const SizedBox()
                                  : ListTile(
                                      isThreeLine: true,
                                      title: Text(
                                          '${user.firstName} ${user.lastName}'),
                                      subtitle: Text(user.type),
                                      trailing: DeleteUserComponent(
                                        id: _id,
                                        jwt: _jwt,
                                        socket: _socket,
                                      ),
                                    );
                            }),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        _message,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Back'))
                    ],
                  ),
      ),
    );
  }
}
