import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/home.dart';
import 'package:glowing_octo_lamp/user_components/get_user.dart';
import 'package:glowing_octo_lamp/user_components/user_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../validate.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key, required this.message});
  final String message;

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailLoginTextController = TextEditingController();
  final _emailLoginFocusNode = FocusNode();
  final _passwordLoginTextController = TextEditingController();
  final _passwordLoginFocusNode = FocusNode();
  bool _isProcessing = false;
  bool _error = false;
  Map<String, dynamic> _response = {};
  String _message = "LOGIN";

  Login(String email, String password) async {
    try {
      await http
          .post(
              Uri.parse(
                  '${ApiConstants.baseUrl}${ApiConstants.port}/users/login'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                'email': email,
                'password': password,
              }))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isProcessing = false;
            _emailLoginTextController.text = "";
            _passwordLoginTextController.text = "";
            _response = json.decode(response.body);
          });
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => GetUserComponent(
          //         jwt: _response['jwt'], id: _response['user']['_id'])));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserMenuComponent(response: _response)));
        } else {
          setState(() {
            _isProcessing = false;
            _error = true;

            _response = json.decode(response.body);
          });
          throw Exception('Failed to login.');
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
    super.initState();
    _message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _error
          ? SafeArea(
              child: Column(
                children: [
                  Text(
                    _message,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    _response.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _emailLoginTextController.text = "";
                          _passwordLoginTextController.text = "";
                          _error = false;
                          _response = {};
                        });
                      },
                      child: const Text('Back'))
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                _emailLoginFocusNode.unfocus();
                _passwordLoginFocusNode.unfocus();
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _message,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        TextFormField(
                          autocorrect: false,
                          cursorColor: Colors.black,
                          controller: _emailLoginTextController,
                          focusNode: _emailLoginFocusNode,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextFormField(
                          autocorrect: false,
                          obscureText: true,
                          cursorColor: Colors.black,
                          controller: _passwordLoginTextController,
                          focusNode: _passwordLoginFocusNode,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        _isProcessing
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home()));
                                          },
                                          child: const Text(
                                            'Back',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            _emailLoginFocusNode.unfocus();
                                            _passwordLoginFocusNode.unfocus();

                                            if (_loginFormKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              await Login(
                                                  _emailLoginTextController
                                                      .text,
                                                  _passwordLoginTextController
                                                      .text);
                                            }
                                          },
                                          child: const Text(
                                            'Login',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                  ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
