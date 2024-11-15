import 'dart:convert';

class Chat {
  int? id;
  int? user_id;
  String? message;
  int? is_seller_reply;
  DateTime? created_at;

  Chat({this.id, this.user_id, this.message, this.is_seller_reply, this.created_at});
  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
        id: map["id"], user_id: map["user_id"], message: map["message"], is_seller_reply: map["is_seller_reply"], created_at: DateTime.parse(map["created_at"]));
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "user_id": user_id, "message": message, "is_seller_reply": is_seller_reply, "created_at": created_at?.toIso8601String()};
  }

  @override
  String toString() {
    return 'Chat{id: $id, user_id: $user_id, message: $message, is_seller_reply: $is_seller_reply, created_at: $created_at}';
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