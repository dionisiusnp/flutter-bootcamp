import 'package:marketplace_apps/model/user_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';


class UserApi {
  final String baseUrl = "http://127.0.0.1:8000";
  Client client = Client();

  Future<bool> register(User data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/blog"),
      headers: {"content-type": "application/json"},
      body: userToJson(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(User data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/blog"),
      headers: {"content-type": "application/json"},
      body: userToJson(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
