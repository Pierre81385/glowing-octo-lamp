import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/user_components/get_all_users.dart';
import 'package:glowing_octo_lamp/user_components/get_user.dart';

class UserMenuComponent extends StatefulWidget {
  const UserMenuComponent({super.key, required this.response});
  final Map<String, dynamic> response;

  @override
  State<UserMenuComponent> createState() => _UserMenuComponentState();
}

class _UserMenuComponentState extends State<UserMenuComponent> {
  late Map<String, dynamic> _currentUser;
  late String _id;
  late String _jwt;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.response;
    _id = _currentUser['user']['_id'];
    _jwt = _currentUser['jwt'];
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
                      builder: (context) =>
                          GetUserComponent(jwt: _jwt, id: _id)));
                },
                child: Text('My Profile')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          GetAllUsersComponent(jwt: _jwt, id: _id)));
                },
                child: Text('Get All Users')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back')),
          ],
        ),
      )),
    );
  }
}
