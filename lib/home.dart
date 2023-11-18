import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'user_components/create_user.dart';
import 'auth/login.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.socket});
  final IO.Socket socket;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late IO.Socket _socket;
  bool login = true;
  ScrollController _listViewScrollController = new ScrollController();

  @override
  void initState() {
    _socket = widget.socket;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<Widget> _switch = [
      LoginComponent(
        message: 'Welcome',
        socket: _socket,
      ),
      CreateUserComponent(
        socket: _socket,
      )
    ];
    void switcher() {
      _listViewScrollController.animateTo(
          login
              ? _listViewScrollController.position.minScrollExtent
              : _listViewScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
                child: SizedBox(
          height: height * 2,
          width: width,
          child: ListView(
            controller: _listViewScrollController,
            children: [
              SizedBox(height: height, width: width, child: _switch[0]),
              SizedBox(height: height, width: width, child: _switch[1])
            ],
          ),
        ))
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Text('Welcome'),
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: OutlinedButton(
            //               onPressed: () {
            //                 Navigator.of(context).push(MaterialPageRoute(
            //                     builder: (context) => CreateUserComponent()));
            //               },
            //               child: const Text(
            //                 'Register',
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: OutlinedButton(
            //               onPressed: () {
            //                 Navigator.of(context).push(MaterialPageRoute(
            //                     builder: (context) => LoginComponent(
            //                           message: "LOGIN",
            //                         )));
            //               },
            //               child: const Text(
            //                 'Login',
            //                 style: TextStyle(color: Colors.black),
            //               )),
            //         )
            //       ],
            //     )
            //   ],
            // ),
            ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            setState(() {
              login = !login;
            });
            switcher();
          },
          label: !login
              ? Icon(
                  Icons.login_outlined,
                  color: Colors.white,
                  size: 50,
                )
              : Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
        ));
  }
}
