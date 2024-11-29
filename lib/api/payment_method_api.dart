import 'package:marketplace_apps/model/payment_method_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
class PaymentMethodApi {
  final String baseUrl = "http://127.0.0.1:8002";
  Client client = Client();

  Future<List<PaymentMethod>> getChats() async {
    final response = await client.get(Uri.parse("$baseUrl/api/payment-method"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<PaymentMethod> chats = data.map<PaymentMethod>((item) => PaymentMethod.fromJson(item)).toList();

      return chats;
    } else {
      return [];
    }
  }

  Future<bool> createChat(PaymentMethod data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    
    final response = await client.post(
      Uri.parse("$baseUrl/api/payment-method"),
      headers: {"content-type": "application/json"},
      body: paymentMehtodToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateChat(PaymentMethod data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/payment-method/${data.id}"),
      headers: {"content-type": "application/json"},
      body: paymentMehtodToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteChat(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/payment-method/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}