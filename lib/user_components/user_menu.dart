import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/product_components/read_all_products.dart';
import 'package:glowing_octo_lamp/user_components/read_all_users.dart';
import 'package:glowing_octo_lamp/user_components/read_one_user.dart';
import 'package:glowing_octo_lamp/auth/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/user_model.dart';

class UserMenuComponent extends StatefulWidget {
  const UserMenuComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<UserMenuComponent> createState() => _UserMenuComponentState();
}

class _UserMenuComponentState extends State<UserMenuComponent> {
  late String _jwt;
  late User _user;
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _jwt = widget.jwt;
    _user = widget.user;
    _socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetUserComponent(
                            jwt: _jwt,
                            user: _user,
                            socket: _socket,
                          )));
                },
                child: Text('Get User')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllUsersComponent(
                            jwt: _jwt,
                            id: _user.id,
                            socket: _socket,
                          )));
                },
                child: Text('All Users')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllProductsComponent(
                            user: _user,
                            jwt: _jwt,
                            socket: _socket,
                          )));
                },
                child: Text('Manage Product')),
            OutlinedButton(
                onPressed: () {
                  _socket.disconnect();
                  setState(() {
                    _jwt = "";
                    _user = User(
                        id: 'logout',
                        firstName: 'logout',
                        lastName: 'logout',
                        email: 'logout',
                        password: 'logout',
                        type: 'logout');
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginComponent(
                            message: 'Welcome!',
                          )));
                },
                child: Text('Logout')),
          ],
        ),
      )),
    );
  }
}
