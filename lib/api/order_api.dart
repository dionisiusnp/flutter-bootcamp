import 'package:marketplace_apps/model/order_model.dart';
import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';

import 'package:marketplace_apps/util/config.dart';
class OrderApi {
  Client client = Client();

  Future<List<Order>> getOrders() async {
    final headers = await Auth.getHeaders();
    final response = await client.get(Uri.parse("${Config().baseUrl}/order"), headers: headers);
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
    final headers = await Auth.getHeaders();
    final response = await client.post(
      Uri.parse("${Config().baseUrl}/order"),
      headers: headers,
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
    final headers = await Auth.getHeaders();
    final response = await client.put(
      Uri.parse("${Config().baseUrl}/order/${data.id}"),
      headers: headers,
      body: orderToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrder(int id) async {
    final headers = await Auth.getHeaders();
    final response = await client.delete(
      Uri.parse("${Config().baseUrl}/order/$id"),
      headers: headers,
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}