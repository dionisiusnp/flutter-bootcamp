import 'dart:convert';

class Chat {
  int? id; // Untuk create dan update message
  int? userId;
  String? message; // Untuk create dan update message
  int? isSellerReply; // Untuk create dan update message
  String? latestMessageTime; // Untuk daftar chat
  String? latestMessage; // Untuk daftar chat
  User? user; // Untuk daftar chat

  Chat({
    this.id,
    this.userId,
    this.message,
    this.isSellerReply,
    this.latestMessageTime,
    this.latestMessage,
    this.user,
  });

  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      userId: map['user_id'],
      message: map['message'],
      isSellerReply: map['is_seller_reply'],
      latestMessageTime: map['latest_message_time'],
      latestMessage: map['latest_message'],
      user: map['userable'] != null ? User.fromJson(map['userable']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "message": message,
      "is_seller_reply": isSellerReply,
    };
  }

  @override
  String toString() {
    return 'Chat{id: $id, userId: $userId, message: $message, isSellerReply: $isSellerReply, '
        'latestMessageTime: $latestMessageTime, latestMessage: $latestMessage, user: $user}';
  }
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}

List<Chat> chatFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Chat>.from((data as List).map((item) => Chat.fromJson(item)));
}

String chatToJson(Chat data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}