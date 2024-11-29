import 'dart:convert';

class Wishlist {
  int? id;
  int? productId;
  int? buyerId;
  DateTime? createdAt;

  Wishlist({
    this.id,
    this.productId,
    this.buyerId,
    this.createdAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      productId: json['product_id'],
      buyerId: json['buyer_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'buyer_id': buyerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Wishlist{id: $id, productId: $productId, buyerId: $buyerId, createdAt: $createdAt}';
  }
}

List<Wishlist> wishlistFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Wishlist>.from((data as List).map((item) => Wishlist.fromJson(item)));
}

String wishlistToJson(Wishlist data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}