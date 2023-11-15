import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/login.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../validate.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};
  String _selectedtype = "General";

  @override
  void initState() {
    super.initState();
    _socket = widget.socket;
  }

  Future<void> createUser(String firstName, String lastName, String email,
      String password, String type) async {
    try {
      await http
          .post(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.port}/users/create'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'password': password,
                'type': type
              }))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _response = json.decode(response.body);
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginComponent(
                    message: 'Success! You can now login!',
                    socket: _socket,
                  )));
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
            _response = json.decode(response.body);
          });
          throw Exception('Failed to create new user.');
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
    return Scaffold(
      body: SafeArea(
          child: !_error
              ? GestureDetector(
                  onTap: () {
                    _firstNameFocusNode.unfocus();
                    _lastNameFocusNode.unfocus();
                    _emailFocusNode.unfocus();
                    _passwordFocusNode.unfocus();
                    _confirmPasswordFocusNode.unfocus();
                    _typeFocusNode.unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _createUserFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('REGISTER'),
                          TextFormField(
                            autocorrect: false,
                            controller: _firstNameTextController,
                            focusNode: _firstNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _lastNameTextController,
                            focusNode: _lastNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _emailTextController,
                            focusNode: _emailFocusNode,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _passwordTextController,
                            focusNode: _passwordFocusNode,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: _confirmPasswordTextController,
                            focusNode: _confirmPasswordFocusNode,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          DropdownButtonFormField(
                            value: _selectedtype,
                            items: dropdownItems,
                            focusNode: _typeFocusNode,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Permission Level",
                              labelStyle: TextStyle(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedtype = value!;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                              _isProcessing
                                  ? const CircularProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
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
                                              await createUser(
                                                  _firstNameTextController.text,
                                                  _lastNameTextController.text,
                                                  _emailTextController.text,
                                                  _passwordTextController.text,
                                                  _selectedtype);
                                            }
                                          },
                                          child: const Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : !_error
                  ? Column(
                      children: [
                        Text(_response.toString()),
                        const Text('SUCCESS'),
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _error = false;
                                _firstNameTextController.text = "";
                                _lastNameTextController.text = "";
                                _emailTextController.text = "";
                                _passwordTextController.text = "";
                                _confirmPasswordTextController.text = "";
                                _selectedtype = "Training";
                                _response = {};
                              });
                            },
                            child: const Text('Ok'))
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          _message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          _response.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back'))
                      ],
                    )),
    );
  }
}
