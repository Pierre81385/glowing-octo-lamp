import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> getAll(
      String endpoint, String auth, IO.Socket socket) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Authorization": auth, "Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to read data');
    }
  }

  Future<Map<String, dynamic>> getOne(
      String endpoint, String auth, IO.Socket socket) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint/'),
      headers: {"Authorization": auth, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to read data');
    }
  }

  Future<Map<String, dynamic>> create(
      String endpoint, Map<String, dynamic> data, IO.Socket socket) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to create data');
    }
  }

  Future<Map<String, dynamic>> createWithAUth(String endpoint,
      Map<String, dynamic> data, String auth, IO.Socket socket) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Authorization": auth, "Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to create data');
    }
  }

  Future<Map<String, dynamic>> update(String endpoint, String auth,
      Map<String, dynamic> data, IO.Socket socket) async {
    print('request URI: $baseUrl/$endpoint/${data['_id']}');
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint/${data['_id']}'),
      headers: {"Authorization": auth, "Content-Type": "application/json"},
      body: json.encode(data),
    );
    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<Map<String, dynamic>> deleteOne(
      String endpoint, String auth, IO.Socket socket) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Authorization": auth, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
