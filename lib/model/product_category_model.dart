import 'dart:convert';

class ProductCategory {
  int? id;
  String? icon;
  String? name;
  DateTime? created_at;

  ProductCategory({this.id, this.icon, this.name, this.created_at});
  factory ProductCategory.fromJson(Map<String, dynamic> map) {
    return ProductCategory(
        id: map["id"],
        icon: map["icon"],
        name: map["name"],
        created_at: DateTime.parse(map["created_at"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "icon": icon,
      "name": name,
      "created_at": created_at?.toIso8601String()
    };
  }

  @override
  String toString() {
    return 'ProductCategory{id: $id, icon: $icon, name: $name,  created_at: $created_at}';
  }
}

List<ProductCategory> productCategoryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ProductCategory>.from(
      (data as List).map((item) => ProductCategory.fromJson(item)));
}

String productCategoryToJson(ProductCategory data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}