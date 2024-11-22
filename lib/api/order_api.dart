import 'package:marketplace_apps/model/order_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
class OrderApi {
  final String baseUrl = "http://127.0.0.1:8002";
  Client client = Client();

  Future<List<Order>> getOrders() async {
    final response = await client.get(Uri.parse("$baseUrl/api/chat"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<Order> orders = data.map<Order>((item) => Order.fromJson(item)).toList();

      return orders;
    } else {
      return [];
    }
  }

  Future<bool> createOrder(Order data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    
    final response = await client.post(
      Uri.parse("$baseUrl/api/chat"),
      headers: {"content-type": "application/json"},
      body: orderToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrder(Order data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/chat/${data.id}"),
      headers: {"content-type": "application/json"},
      body: orderToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrder(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/chat/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}