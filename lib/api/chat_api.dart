import 'package:marketplace_apps/model/chat_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
class ChatApi {
  final String baseUrl = "http://127.0.0.1:8002";
  Client client = Client();

  Future<List<Chat>> getChats() async {
    final response = await client.get(Uri.parse("$baseUrl/api/chat"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<Chat> chats = data.map<Chat>((item) => Chat.fromJson(item)).toList();

      return chats;
    } else {
      return [];
    }
  }

  Future<bool> createChat(Chat data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    
    final response = await client.post(
      Uri.parse("$baseUrl/api/chat"),
      headers: {"content-type": "application/json"},
      body: chatToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateChat(Chat data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/chat/${data.id}"),
      headers: {"content-type": "application/json"},
      body: chatToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteChat(int id) async {
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