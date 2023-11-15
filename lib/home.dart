import 'package:flutter/material.dart';
import 'constants.dart';
import 'user_components/create_user.dart';
import 'user_components/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late IO.Socket socket;

  void connectToServer() {
    socket.connect();
  }

  @override
  void initState() {
    super.initState();
    socket =
        IO.io('${ApiConstants.baseUrl}${ApiConstants.port}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    connectToServer();
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
                          builder: (context) => CreateUserComponent(
                                socket: socket,
                              )));
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
                                socket: socket,
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
