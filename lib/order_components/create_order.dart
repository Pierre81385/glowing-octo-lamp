import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/api_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../user_components/user_menu.dart';

class CreateOrderComponent extends StatefulWidget {
  const CreateOrderComponent(
      {super.key, required this.user, required this.jwt, required this.socket});
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<CreateOrderComponent> createState() => _CreateOrderComponentState();
}

class _CreateOrderComponentState extends State<CreateOrderComponent> {
  late User _user;
  late Order _order;
  late String _jwt;
  late IO.Socket _socket;
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  bool _isProcessing = true;
  bool _error = false;
  String _listMessage = "";
  String _objectMessage = "";
  List<Product> _responseList = [];
  Map<String, dynamic> _responseObject = {};
  List<Map<String, dynamic>> _cart = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    getAllProd();
    _socket.on("update_product_list", (data) {
      getAllProd();
    });
  }

  Future<void> getAllProd() async {
    try {
      final resp = await api.getAll("products/", _jwt, _socket);
      final parsed = (resp['products'] as List).cast<Map<String, dynamic>>();
      final map =
          parsed.map<Product>((json) => Product.fromJson(json)).toList();
      setState(() {
        _responseList = map;
        _error = false;
        _listMessage = "Found users!";
        _isProcessing = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _listMessage = e.toString();
        _isProcessing = false;
      });
    }
  }

  Future<void> createOrder(order) async {
    try {
      final resp =
          await api.createWithAUth('orders/create', order, _jwt, _socket);
      setState(() {
        _error = false;
        _isProcessing = false;
        _responseObject = resp;
        _objectMessage = resp["message"];
        _order = Order.fromJson(resp["order"]);
      });
      success();
    } catch (e) {
      setState(() {
        _error = true;
        _isProcessing = false;
        _objectMessage = e.toString();
      });
    }
  }

  void success() {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) =>
    //     GetAllOrdersComponent(
    //           user: _user,
    //           jwt: _jwt,
    //           socket: _socket,
    //         )));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _key,
      drawer: Drawer(
          child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text('My Cart'),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _cart.length,
              itemBuilder: (BuildContext context, int index) {
                return _cart[index]['count'] == 0
                    ? const SizedBox()
                    : ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              _cart[index]['count']--;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                        title: Text(_responseList[index].name),
                        subtitle: Text(_cart[index]['count'].toString()),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              _cart[index]['count']++;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_up),
                        ),
                      );
              }),
        ],
      )),
      body: SafeArea(
        child: _isProcessing
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Back')),
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
                          'List message: ${_listMessage}',
                        ),
                        Text(
                          'List response: ${_responseList.toString()}',
                        ),
                        Text(
                          'Object message: ${_objectMessage}',
                        ),
                        Text(
                          'Object response: ${_responseObject.toString()}',
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back_ios_new_outlined)),
                            IconButton.filled(
                                onPressed: () {
                                  _key.currentState!.openDrawer();
                                },
                                icon: Icon(Icons.shopping_cart))
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _responseList.length,
                            itemBuilder: (BuildContext context, int index) {
                              for (var i = 0; i < _responseList.length; i++) {
                                _cart.add({
                                  "id": _responseList[index].id,
                                  "count": 0
                                });
                              }
                              Product product = _responseList[index];
                              return SizedBox(
                                width: width,
                                child: ListTile(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    isThreeLine: true,
                                    leading: IconButton.filled(
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _cart[index]['count']--;
                                        });
                                      },
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(product.name),
                                        Row(
                                          children: [
                                            Text(
                                                '\$${product.price.toString()}'),
                                            _cart[index]['count'] > 0
                                                ? Text(
                                                    ' x ${_cart[index]['count'].toString()}')
                                                : SizedBox()
                                          ],
                                        )
                                      ],
                                    ),
                                    subtitle: Text(product.description),
                                    trailing: IconButton.filled(
                                      icon: Icon(Icons.arrow_drop_up,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _cart[index]['count']++;
                                        });
                                      },
                                    )),
                              );
                            }),
                      ),
                    ],
                  ),
      ),
    );
  }
}
