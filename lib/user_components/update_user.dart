import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/get_user.dart';
import 'package:glowing_octo_lamp/user_components/user_menu.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user_model.dart';
import '../validate.dart';

class UpdateUserComponent extends StatefulWidget {
  const UpdateUserComponent({super.key, required this.user, required this.jwt});
  final User user;
  final String jwt;

  @override
  State<UpdateUserComponent> createState() => _UpdateUserComponentState();
}

class _UpdateUserComponentState extends State<UpdateUserComponent> {
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
  late User _user;
  late String _jwt;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _jwt = widget.jwt;
    _user = widget.user;
    print(_user);
  }

  Future<void> updateUser(String id, String firstName, String lastName,
      String email, String password, String type, String token) async {
    try {
      print('${ApiConstants.baseUrl}${ApiConstants.port}/users/${_user.id}');

      await http
          .put(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.port}/users/${_user.id}'),
              headers: {
                "Authorization": token,
                "Content-Type": "application/json"
              },
              body: jsonEncode({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'password': password,
                'type': type
              }))
          .then((response) {
        print(response.statusCode);
        print(response.reasonPhrase);
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GetUserComponent(user: _user, jwt: _jwt)));
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;
          });
          throw Exception('Failed to update new user.');
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
                          const Text('UPDATE'),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _user.firstName,
                            //controller: _firstNameTextController,
                            focusNode: _firstNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            onChanged: (value) {
                              _user.firstName = value;
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _user.lastName,
                            //controller: _lastNameTextController,
                            focusNode: _lastNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _user.lastName = value;
                              });
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            initialValue: _user.email,
                            //controller: _emailTextController,
                            focusNode: _emailFocusNode,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _user.email = value;
                              });
                            },
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(),
                            ),
                          ),
                          TextFormField(
                            autocorrect: false,
                            //initialValue: _user.password,
                            controller: _passwordTextController,
                            focusNode: _passwordFocusNode,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            // onChanged: (value) {
                            //   _user.password = value;
                            // },
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
                            value: _user.type,
                            items: dropdownItems,
                            focusNode: _typeFocusNode,
                            onChanged: (value) {
                              setState(() {
                                _user.type = value!;
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
                                              await updateUser(
                                                  _user.id,
                                                  _user.firstName,
                                                  _user.lastName,
                                                  _user.email,
                                                  _passwordTextController.text,
                                                  _user.type,
                                                  _jwt);
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
