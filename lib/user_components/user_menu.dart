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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton.filled(
                  iconSize: 75,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GetUserComponent(
                              jwt: _jwt,
                              user: _user,
                              socket: _socket,
                            )));
                  },
                  icon: Icon(Icons.person_pin_rounded)),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllUsersComponent(
                            jwt: _jwt,
                            id: _user.id,
                            socket: _socket,
                          )));
                },
                icon: Icon(Icons.group),
                label: Text('Users')),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllProductsComponent(
                            user: _user,
                            jwt: _jwt,
                            socket: _socket,
                          )));
                },
                icon: Icon(Icons.shopping_bag_rounded),
                label: Text('Products')),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllProductsComponent(
                            user: _user,
                            jwt: _jwt,
                            socket: _socket,
                          )));
                },
                icon: Icon(Icons.view_list_rounded),
                label: Text('Orders')),
            ElevatedButton.icon(
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
                            socket: _socket,
                          )));
                },
                icon: Icon(Icons.power_settings_new_rounded),
                label: Text('Logout')),
          ],
        ),
      )),
    );
  }
}
