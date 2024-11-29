import 'dart:convert';

class PaymentMethod {
  int? id;
  String? type;
  String? description;
  int? is_available;

  PaymentMethod({this.id, this.type, this.description, this.is_available});
  factory PaymentMethod.fromJson(Map<String, dynamic> map) {
    return PaymentMethod(
        id: map["id"], type: map["type"], description: map["description"], is_available: map["is_available"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "type": type, "decription": description, "is_available": is_available};
  }

  @override
  String toString() {
    return 'PaymentMethod{id: $id, type: $type, description: $description, is_available: $is_available}';
  }
}

List<PaymentMethod> paymentMethodFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PaymentMethod>.from((data as List).map((item) => PaymentMethod.fromJson(item)));
}

String paymentMehtodToJson(PaymentMethod data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}