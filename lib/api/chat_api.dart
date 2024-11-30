import 'package:marketplace_apps/model/chat_model.dart';
import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';
import 'package:marketplace_apps/util/config.dart';
class ChatApi {
  Client client = Client();

  Future<List<Chat>> getChatsSeller() async {
    final headers = await Auth.getHeaders();
    final response = await client.get(Uri.parse("${Config().baseUrl}/chat/seller"), headers: headers);
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<Chat> chats = data.map<Chat>((item) => Chat.fromJson(item)).toList();

      return chats;
    } else {
      return [];
    }
  }

  Future<List<Chat>> getChats() async {
    final headers = await Auth.getHeaders();
    final response = await client.get(Uri.parse("${Config().baseUrl}/chat"), headers: headers);
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
    final headers = await Auth.getHeaders();
    // print("Creating blog with data: ${blogToJson(data)}");
    final response = await client.post(
      Uri.parse("${Config().baseUrl}/chat"),
      headers: headers,
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
    final headers = await Auth.getHeaders();
    final response = await client.put(
      Uri.parse("${Config().baseUrl}/chat/${data.id}"),
      headers: headers,
      body: chatToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteChat(int id) async {
    final headers = await Auth.getHeaders();
    final response = await client.delete(
      Uri.parse("${Config().baseUrl}/chat/$id"),
      headers: headers,
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}