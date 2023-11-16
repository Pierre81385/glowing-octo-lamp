import 'package:flutter/material.dart';
import 'user_components/create_user.dart';
import 'auth/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void connectToServer() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Welcome'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateUserComponent()));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginComponent(
                                message: "LOGIN",
                              )));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          )
        ],
      )),
    );
  }
}
