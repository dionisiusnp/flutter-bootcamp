import 'package:marketplace_apps/model/order_item_model.dart';
import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';

import 'package:marketplace_apps/util/config.dart';
import 'package:http/http.dart' as http;
class OrderItemApi {
  Client client = Client();

  Future<List<OrderItemModel>> getOrdersItem() async {
    final response = await client.get(Uri.parse("${Config().baseUrl}/order-item"));
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

  Future<bool> createOrderItem({
    required int buyerId,
    required int productId,
    required int quantity,
    required int price,
    required int shippingCost,
  }) async {

    try {
      final headers = await Auth.getHeaders();
      final body = {
        'buyer_id': buyerId,
        'product_id': productId,
        'quantity': quantity,
        'price': price,
        'shipping_cost': shippingCost,
      };

      final response = await client.post(
        Uri.parse("${Config().baseUrl}/order-item"),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderItem(OrderItemModel data) async {
    final response = await client.put(
      Uri.parse("${Config().baseUrl}/order-item/${data.id}"),
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
      Uri.parse("${Config().baseUrl}/order-item/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}