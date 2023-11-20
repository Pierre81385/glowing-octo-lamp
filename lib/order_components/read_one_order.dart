import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../helpers/constants.dart';
import '../models/api_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import 'read_all_orders.dart';

class GetOrderComponent extends StatefulWidget {
  const GetOrderComponent(
      {super.key,
      required this.id,
      required this.user,
      required this.jwt,
      required this.socket});
  final String id;
  final User user;
  final String jwt;
  final IO.Socket socket;

  @override
  State<GetOrderComponent> createState() => _GetOrderComponentState();
}

class _GetOrderComponentState extends State<GetOrderComponent> {
  late String _id;
  late Order _order;
  late User _user;
  late String _jwt;
  late IO.Socket _socket;
  bool _isProcessing = true;
  bool _error = false;
  String _message = "";
  double _totalPrice = 0.0;
  Map<String, dynamic> _response = {};
  List<Product> _productResponse = [];

  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _user = widget.user;
    _jwt = widget.jwt;
    _socket = widget.socket;
    getorderById(_id);
    getAllProd();
  }

  Future<void> getorderById(id) async {
    try {
      final resp = await api.getOne("orders/$_id", _jwt, _socket);
      setState(() {
        _response = resp;
        _order = Order.fromJson(_response['order']);
        _error = false;
        _message = "Found a order!";
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

  Future<void> getAllProd() async {
    try {
      final resp = await api.getAll("products/", _jwt, _socket);
      final parsed = (resp['products'] as List).cast<Map<String, dynamic>>();
      final map =
          parsed.map<Product>((json) => Product.fromJson(json)).toList();
      setState(() {
        _productResponse = map;
        _error = false;
        _message = "Found users!";
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
              ? Column(
                  children: [
                    const CircularProgressIndicator(),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GetAllOrdersComponent(
                                    user: _user,
                                    jwt: _jwt,
                                    socket: _socket,
                                  )));
                        },
                        child: const Text('Back'))
                  ],
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
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back'))
                        ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_outlined)),
                              ]),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Order Number: ${_order.orderNumber}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_order.placedBy),
                                Text(
                                  'Order Status: ${_order.orderStatus}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _order.orderItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Product item = _order.orderItems[index];

                                      _totalPrice = item.price + _totalPrice;
                                      return ListTile(
                                        title: Text(item.name),
                                        subtitle: Text(item.description),
                                        trailing: Text('\$${item.price}'),
                                      );
                                    })
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                _order.orderItems.length == 1
                                    ? Text('1 item ordered.')
                                    : Text(
                                        '${_order.orderItems.length.toString()} items ordered.'),
                                Text('Total cost: \$${_totalPrice}')
                              ],
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         UpdateorderComponent(
                                //           user: _user,
                                //           order: _order,
                                //           jwt: _jwt,
                                //           socket: _socket,
                                //         )));
                              },
                              child: const Text('Update'))
                        ],
                      ),
                    )),
    );
  }
}
