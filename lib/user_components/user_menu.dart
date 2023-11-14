import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/get_all_users.dart';
import 'package:glowing_octo_lamp/user_components/get_user.dart';
import 'package:glowing_octo_lamp/user_components/login.dart';

import '../models/user_model.dart';

class UserMenuComponent extends StatefulWidget {
  const UserMenuComponent({super.key, required this.user, required this.jwt});
  final User user;
  final String jwt;

  @override
  State<UserMenuComponent> createState() => _UserMenuComponentState();
}

class _UserMenuComponentState extends State<UserMenuComponent> {
  late String _jwt;
  late User _user;

  @override
  void initState() {
    super.initState();
    _jwt = widget.jwt;
    _user = widget.user;
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
                          )));
                },
                child: Text('My Profile')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          GetAllUsersComponent(jwt: _jwt, id: _user.id)));
                },
                child: Text('Get All Users')),
            OutlinedButton(
                onPressed: () {
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
                      builder: (context) =>
                          LoginComponent(message: 'Welcome!')));
                },
                child: Text('Logout')),
          ],
        ),
      )),
    );
  }
}
