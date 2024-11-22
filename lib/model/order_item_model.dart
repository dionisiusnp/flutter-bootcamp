import 'dart:convert';

class OrderItemModel {
  int? order_id;
  String? product_id;
  int? quantity;
  int? price;
  int? shipping_cost;
  int? total_sub;

  OrderItemModel({this.order_id, this.product_id, this.quantity, this.price, this.shipping_cost, this.total_sub});
  factory OrderItemModel.fromJson(Map<String, dynamic> map) {
    return OrderItemModel(
        order_id: map["order_id"], product_id: map["product_id"], quantity: map["quantity"], price: map["price"], shipping_cost: map["shipping_cost"], total_sub: map["total_sub"]);
  }

  Map<String, dynamic> toJson() {
    return {"order_id": order_id, "product_id": product_id, "quantity": quantity, "price": price, "shipping_cost": shipping_cost, "total_sub": total_sub};
  }

  @override
  String toString() {
    return 'OrderItemModel{order_id: $order_id, product_id: $product_id, quantity: $quantity, price: $price, shipping_cost: $shipping_cost, total_sub: $total_sub}';
  }
}

List<OrderItemModel> orderitemmodelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<OrderItemModel>.from((data as List).map((item) => OrderItemModel.fromJson(item)));
}

String orderitemmodelToJson(OrderItemModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}