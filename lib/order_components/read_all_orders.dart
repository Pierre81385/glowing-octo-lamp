import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/product_components/create_product.dart';
import 'package:glowing_octo_lamp/product_components/delete_product.dart';
import 'package:glowing_octo_lamp/product_components/read_one_product.dart';
import 'package:glowing_octo_lamp/user_components/user_menu.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/api_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import 'create_order.dart';

class GetAllOrdersComponent extends StatefulWidget {
  const GetAllOrdersComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<GetAllOrdersComponent> createState() => _GetAllOrdersComponentState();
}

class _GetAllOrdersComponentState extends State<GetAllOrdersComponent> {
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  List<Order> _response = [];
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    _socket.on("update_orders_list", (data) {
      getAllOrders();
    });
    getAllOrders();
    super.initState();
  }

  Future<void> getAllOrders() async {
    try {
      final resp = await api.getAll("orders/", _jwt, _socket);
      print(resp);
      final parsed = (resp['orders'] as List).cast<Map<String, dynamic>>();
      final map = parsed.map<Order>((json) => Order.fromJson(json)).toList();
      setState(() {
        _response = map;
        _error = false;
        _message = "Found orders!";
        _isProcessing = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _message = e.toString();
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isProcessing
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon:
                                const Icon(Icons.arrow_back_ios_new_outlined)),
                      ],
                    )
                  ],
                ),
              )
            : _error
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          _message,
                        ),
                        Text(
                          _response.toString(),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserMenuComponent(
                                        user: _user,
                                        jwt: _jwt,
                                        socket: _socket,
                                      )));
                            },
                            child: const Text('Back')),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserMenuComponent(
                                            user: _user,
                                            jwt: _jwt,
                                            socket: _socket,
                                          )));
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _response.length,
                            itemBuilder: (BuildContext context, int index) {
                              Order order = _response[index];

                              return ListTile(
                                  onTap: () {
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             GetProductComponent(
                                    //               id: product.id,
                                    //               user: _user,
                                    //               jwt: _jwt,
                                    //               socket: _socket,
                                    //             )));
                                  },
                                  isThreeLine: true,
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        order.orderStatus,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  title: Text(order.placedBy),
                                  subtitle: Text(
                                      'Order Number: ${order.orderNumber}'),
                                  trailing: Text('Cancel Order')
                                  // DeleteProductComponent(
                                  //   id: order.id,
                                  //   jwt: _jwt,
                                  //   socket: _socket,
                                  // ) //delete component here,
                                  );
                            }),
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateOrderComponent(
                                      user: _user,
                                      jwt: _jwt,
                                      socket: _socket,
                                    )));
                          },
                          child: const Text('New Order')),
                    ],
                  ),
      ),
    );
  }
}
