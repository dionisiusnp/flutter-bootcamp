import 'dart:io';
import 'dart:typed_data';

import 'package:marketplace_apps/model/chat_model.dart';
import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';
import 'package:marketplace_apps/util/config.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> createChat({
    required int userId,
    required String message,
    required bool isSellerReply,
    Uint8List? fileBytes, // Data file dalam format byte array
    String? fileName, // Nama file
  }) async {
    try {
      final headers = await Auth.getHeaders();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Config().baseUrl}/chat"),
      );
      request.headers.addAll(headers);
      request.fields['user_id'] = userId.toString();
      request.fields['message'] = message;
      request.fields['is_seller_reply'] = isSellerReply.toString();
      if (fileBytes != null && fileName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            fileBytes,
            filename: fileName,
          ),
        );
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        // var responseBody = await response.stream.bytesToString();
        // print("Gagal mengirim chat: ${response.statusCode} - $responseBody");
        return false;
      }
    } catch (e) {
      // print("Terjadi kesalahan: $e");
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
