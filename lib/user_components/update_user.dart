import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/read_one_user.dart';
import '../models/api_model.dart';
import '../models/user_model.dart';
import '../helpers/constants.dart';
import '../helpers/validate.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UpdateUserComponent extends StatefulWidget {
  const UpdateUserComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

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
  final _typeFocusNode = FocusNode();
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = false;
  bool _error = false;
  String _message = "";
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _jwt = widget.jwt;
    _user = widget.user;
    _socket = widget.socket;
  }

  Future<void> updateOneUser(
    User user,
  ) async {
    try {
      final resp = await api.update('users', _jwt, user.toJson(), _socket);
      setState(() {
        _isProcessing = false;
      });
      _socket.emit('_update_successful', resp);
      updateSuccess();
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
      });
    }
  }

  void updateSuccess() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GetUserComponent(
              user: _user,
              currentUser: _user,
              jwt: _jwt,
              socket: _socket,
            )));
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
          child: _error
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(_message),
                      Text(_response.toString()),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _error = false;
                              _firstNameTextController.text = "";
                              _lastNameTextController.text = "";
                              _emailTextController.text = "";
                              _response = {};
                            });
                          },
                          child: const Text('Ok'))
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    _firstNameFocusNode.unfocus();
                    _lastNameFocusNode.unfocus();
                    _emailFocusNode.unfocus();
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
                            focusNode: _firstNameFocusNode,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _user.firstName = value;
                              });
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
                                            _typeFocusNode.unfocus();
                                            if (_createUserFormKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              await updateOneUser(_user);
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
                )),
    );
  }
}
