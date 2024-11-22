import 'package:marketplace_apps/model/order_item_model.dart';
import 'package:marketplace_apps/model/order_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
class OrderItemApi {
  final String baseUrl = "http://127.0.0.1:8002";
  Client client = Client();

  Future<List<OrderItemModel>> getOrdersItem() async {
    final response = await client.get(Uri.parse("$baseUrl/api/chat"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<OrderItemModel> ordersItem = data.map<OrderItemModel>((item) => OrderItemModel.fromJson(item)).toList();

      return ordersItem;
    } else {
      return [];
    }
  }

  Future<bool> createOrderItem(OrderItemModel data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    
    final response = await client.post(
      Uri.parse("$baseUrl/api/chat"),
      headers: {"content-type": "application/json"},
      body: orderitemmodelToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrderItem(OrderItemModel data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/chat/${data.id}"),
      headers: {"content-type": "application/json"},
      body: orderitemmodelToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrderItem(int id) async {
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