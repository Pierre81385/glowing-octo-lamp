import 'package:flutter/material.dart';
import 'user_components/create_user.dart';
import 'auth/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool login = true;
  ScrollController _listViewScrollController = new ScrollController();

  final List<Widget> _switch = [
    LoginComponent(
      message: 'Welcome',
    ),
    CreateUserComponent()
  ];
  void switcher() {
    _listViewScrollController.animateTo(
        login
            ? _listViewScrollController.position.minScrollExtent
            : _listViewScrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 134, 151, 184),
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
                ? Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'New User',
                    style: TextStyle(color: Colors.white),
                  )));
  }
}
