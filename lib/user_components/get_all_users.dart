import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/constants.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import './delete_user.dart';

class GetAllUsersComponent extends StatefulWidget {
  const GetAllUsersComponent({super.key, required this.jwt, required this.id});
  final String jwt;
  final String id;

  @override
  State<GetAllUsersComponent> createState() => _GetAllUsersComponentState();
}

class _GetAllUsersComponentState extends State<GetAllUsersComponent> {
  late String _jwt;
  late String _id;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  List<User> _response = [];

  Future<void> getAllUsers(String token) async {
    try {
      await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/users/'),
        headers: {"Authorization": token, "Content-Type": "application/json"},
      ).then((response) {
        final parsed =
            (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response =
                parsed.map<User>((json) => User.fromJson(json)).toList();
          });
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response =
                parsed.map<User>((json) => User.fromJson(json)).toList();
          });
          throw Exception('Failed to get all users.');
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
  void initState() {
    _jwt = widget.jwt;
    _id = widget.id;
    getAllUsers(_jwt);
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
                                  ? SizedBox()
                                  : ListTile(
                                      isThreeLine: true,
                                      title: Text(
                                          '${user.firstName} ${user.lastName}'),
                                      subtitle: Text(user.role),
                                      trailing: DeleteUserComponent(
                                          id: _id, jwt: _jwt),
                                    );
                            }),
                      ),
                    ],
                  )
                : Column(
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
    );
  }
}
