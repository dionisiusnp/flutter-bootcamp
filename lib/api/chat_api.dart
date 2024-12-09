import 'package:marketplace_apps/model/chat_model.dart';
import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';
import 'package:marketplace_apps/util/config.dart';

class ChatApi {
  Client client = Client();

  Future<List<Chat>> getChatsSeller() async {
    final headers = await Auth.getHeaders();
    final response = await client
        .get(Uri.parse("${Config().baseUrl}/chat/seller"), headers: headers);
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map<Chat>((item) => Chat.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  Future<List<Chat>> getChatsBuyer(int userId) async {
    final headers = await Auth.getHeaders();
    final response = await client.get(
        Uri.parse("${Config().baseUrl}/chat?user_id=$userId"),
        headers: headers);
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Chat>((item) => Chat.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load chats: ${response.statusCode}");
    }
  }

  Future<bool> createChat(
      {required int userId, required String message}) async {
    final headers = await Auth.getHeaders();
    final bool isSellerReply = userId <= 1;
    final Chat chatData = Chat(
      userId: userId,
      message: message,
      isSellerReply: isSellerReply,
    );

    final response = await client.post(
      Uri.parse("${Config().baseUrl}/chat"),
      headers: headers,
      body: chatToJson(chatData),
    );
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
