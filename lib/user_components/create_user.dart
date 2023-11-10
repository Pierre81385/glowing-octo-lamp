import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../validate.dart';

class CreateUserComponent extends StatefulWidget {
  const CreateUserComponent({super.key});

  @override
  State<CreateUserComponent> createState() => _CreateUserComponentState();
}

class _CreateUserComponentState extends State<CreateUserComponent> {
  final _CreateUserFormKey = GlobalKey<FormState>();
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
  final _roleFocusNode = FocusNode();
  bool _isProcessing = false;
  bool _success = false;
  bool _error = false;
  Map<String, dynamic> _response = {};
  String _selectedRole = "Training";

  Future<void> createUser(String firstName, String lastName, String email,
      String password, String role) async {
    String name = "$firstName $lastName";

    var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.port}/users/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role
        }));

    if (response.statusCode == 200) {
      setState(() {
        _isProcessing = false;
        _success = true;
        _response = json.decode(response.body);
      });
    } else {
      setState(() {
        _isProcessing = false;
        _success = true;
        _error = true;
        _response = json.decode(response.body);
      });
      throw Exception('Failed to create new user.');
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Training"), value: "Training"),
      DropdownMenuItem(child: Text("BarBack"), value: "BarBack"),
      DropdownMenuItem(child: Text("Expedite"), value: "Expedite"),
      DropdownMenuItem(child: Text("Bartender"), value: "Bartender"),
      DropdownMenuItem(child: Text("Server"), value: "Server"),
      DropdownMenuItem(child: Text("Manager"), value: "Manager"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !_success
            ? GestureDetector(
                onTap: () {
                  _firstNameFocusNode.unfocus();
                  _lastNameFocusNode.unfocus();
                  _emailFocusNode.unfocus();
                  _passwordFocusNode.unfocus();
                  _confirmPasswordFocusNode.unfocus();
                  _roleFocusNode.unfocus();
                },
                child: Form(
                  key: _CreateUserFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        controller: _firstNameTextController,
                        focusNode: _firstNameFocusNode,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        style: TextStyle(),
                        decoration: InputDecoration(
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
                        style: TextStyle(),
                        decoration: InputDecoration(
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
                        style: TextStyle(),
                        decoration: InputDecoration(
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
                        style: TextStyle(),
                        decoration: InputDecoration(
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
                        style: TextStyle(),
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedRole,
                        items: dropdownItems,
                        focusNode: _roleFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : OutlinedButton(
                              onPressed: () async {
                                _firstNameFocusNode.unfocus();
                                _lastNameFocusNode.unfocus();
                                _emailFocusNode.unfocus();
                                _passwordFocusNode.unfocus();
                                _confirmPasswordFocusNode.unfocus();
                                _roleFocusNode.unfocus();
                                if (_CreateUserFormKey.currentState!
                                    .validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  await createUser(
                                      _firstNameTextController.text,
                                      _lastNameTextController.text,
                                      _emailTextController.text,
                                      _passwordTextController.text,
                                      _selectedRole);
                                }
                              },
                              child: Text('Submit'))
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  _error
                      ? Text(_response['message'])
                      : Column(
                          children: [
                            Text(_response.toString()),
                            Text('SUCCESS')
                          ],
                        ),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _success = false;
                          _error = false;
                          _firstNameTextController.text = "";
                          _lastNameTextController.text = "";
                          _emailTextController.text = "";
                          _passwordTextController.text = "";
                          _confirmPasswordTextController.text = "";
                          _selectedRole = "Training";
                          _response = {};
                        });
                      },
                      child: Text('Ok'))
                ],
              ),
      ),
    );
  }
}
