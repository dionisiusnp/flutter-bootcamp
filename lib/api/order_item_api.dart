import 'package:marketplace_apps/model/order_item_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:marketplace_apps/util/config.dart';
class OrderItemApi {
  Client client = Client();

  Future<List<OrderItemModel>> getOrdersItem() async {
    final response = await client.get(Uri.parse("${Config().baseUrl}/chat"));
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
      Uri.parse("${Config().baseUrl}/chat"),
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
      Uri.parse("${Config().baseUrl}/chat/${data.id}"),
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
      Uri.parse("${Config().baseUrl}/chat/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}