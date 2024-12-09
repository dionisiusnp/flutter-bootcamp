import 'dart:convert';

class Order {
  int? id;
  int? buyer_id;
  String? payment_method_id;
  int? total_payment;
  String? is_delivery;
  String? is_payment;
  String? is_accept;
  DateTime? created_at;
  List<String>? mediaUrls;
  User? user;

  Order({this.id, this.buyer_id, this.payment_method_id, this.total_payment, this.is_delivery, this.is_payment, this.is_accept, this.created_at, this.mediaUrls, this.user});
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
       id: map["id"], buyer_id: map["buyer_id"], payment_method_id: map["payment_method_id"], total_payment: map["total_payment"], is_delivery: map["is_delivery"], is_payment: map["is_payment"], is_accept: map["is_accept"], created_at: DateTime.parse(map["created_at"]),
       mediaUrls: map["media_urls"] != null
          ? List<String>.from(map["media_urls"].map((url) => url))
          : [],
      user: map["userable"] != null ? User.fromJson(map["userable"]) : null,);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "buyer_id": buyer_id, "payment_method_id": payment_method_id, "total_payment": total_payment, "is_delivery": is_delivery, "is_payment": is_payment, "is_accept": is_accept, "created_at": created_at?.toIso8601String(), "media_urls": mediaUrls, "userable": user?.toJson()};
  }

  @override
  String toString() {
    return 'Order{id: $id, buyer_id: $buyer_id, payment_method_id: $payment_method_id, total_payment: $total_payment, is_delivery: $is_delivery, is_payment: $is_payment, is_accept: $is_accept, created_at: $created_at}';
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

List<Order> orderFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Order>.from((data as List).map((item) => Order.fromJson(item)));
}

String orderToJson(Order data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}