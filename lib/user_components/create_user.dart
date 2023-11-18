import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/auth/login.dart';
import 'package:glowing_octo_lamp/home.dart';
import 'package:glowing_octo_lamp/user_components/user_menu.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';
import '../helpers/validate.dart';
import '../models/api_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/user_model.dart';

class CreateUserComponent extends StatefulWidget {
  const CreateUserComponent({super.key, required this.socket});
  final IO.Socket socket;

  @override
  State<CreateUserComponent> createState() => _CreateUserComponentState();
}

class _CreateUserComponentState extends State<CreateUserComponent> {
  final _createUserFormKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameTextController = TextEditingController();
  final _lastNameFocusNode = FocusNode();
  final _emailTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordTextController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordTextController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  late IO.Socket _socket;
  late User _user;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  String _selectedtype = "General";
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  Future<void> createUser(req) async {
    try {
      final resp = await api.create('users/create', req, _socket);
      setState(() {
        _error = false;
        _isProcessing = false;
        _response = resp;
        _message = resp["message"];
        _user = User.fromJson(resp["user"]);
      });
      success();
    } catch (e) {
      setState(() {
        _error = true;
        _isProcessing = false;
        _message = e.toString();
      });
    }
  }

  void success() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Home(socket: _socket)));
  }

  @override
  void initState() {
    _socket = widget.socket;
    super.initState();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Admin",
          child: Text(
            "Admin",
            style: TextStyle(color: Colors.black),
          )),
      const DropdownMenuItem(
          value: "General",
          child: Text(
            "General",
            style: TextStyle(color: Colors.black),
          )),
      const DropdownMenuItem(
          value: "Limited",
          child: Text(
            "Limited",
            style: TextStyle(color: Colors.black),
          )),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return _error
        ? Expanded(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ERROR'),
                  Text(_message),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _error = false;
                          _firstNameTextController.text = "";
                          _lastNameTextController.text = "";
                          _emailTextController.text = "";
                          _passwordTextController.text = "";
                          _confirmPasswordTextController.text = "";
                          _selectedtype = "General";
                          _response = {};
                        });
                      },
                      child: const Text('Ok'))
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              _firstNameFocusNode.unfocus();
              _lastNameFocusNode.unfocus();
              _emailFocusNode.unfocus();
              _passwordFocusNode.unfocus();
              _confirmPasswordFocusNode.unfocus();
              _typeFocusNode.unfocus();
            },
            child: Form(
              key: _createUserFormKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Card(
                    elevation: 25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_add_rounded,
                          color: Colors.black,
                          size: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autocorrect: false,
                            controller: _firstNameTextController,
                            focusNode: _firstNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "First Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autocorrect: false,
                            controller: _lastNameTextController,
                            focusNode: _lastNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Last Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autocorrect: false,
                            controller: _emailTextController,
                            focusNode: _emailFocusNode,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: _passwordTextController,
                            focusNode: _passwordFocusNode,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: _confirmPasswordTextController,
                            focusNode: _confirmPasswordFocusNode,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedtype,
                            items: dropdownItems,
                            focusNode: _typeFocusNode,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Permission Level",
                              labelStyle: TextStyle(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedtype = value!;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isProcessing
                                  ? const CircularProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) {
                                              // If the button is pressed, return green, otherwise blue
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return Color.fromARGB(
                                                    255, 81, 16, 93);
                                              }
                                              return Colors.black;
                                            }),
                                          ),
                                          onPressed: () async {
                                            _firstNameFocusNode.unfocus();
                                            _lastNameFocusNode.unfocus();
                                            _emailFocusNode.unfocus();
                                            _passwordFocusNode.unfocus();
                                            _confirmPasswordFocusNode.unfocus();
                                            _typeFocusNode.unfocus();
                                            if (_createUserFormKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              await createUser({
                                                "firstName":
                                                    _firstNameTextController
                                                        .text,
                                                "lastName":
                                                    _lastNameTextController
                                                        .text,
                                                "email":
                                                    _emailTextController.text,
                                                "password":
                                                    _passwordTextController
                                                        .text,
                                                "type": _selectedtype
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
