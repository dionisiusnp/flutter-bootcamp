import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/model/product_category_model.dart';
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';
import 'package:marketplace_apps/util/config.dart';
class ProductCategoryApi {
  Client client = Client();

    Future<List<ProductCategory>> getProductCategory() async {
      final headers = await Auth.getHeaders();
      final response = await client.get(Uri.parse("${Config().baseUrl}/product-category"), headers: headers);
     
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as List<dynamic>;

        // Mapping data ke model
        return data.map<ProductCategory>((item) => ProductCategory.fromJson(item)).toList();
      } else {
        print("Failed to load categories. Status code: ${response.statusCode}");
        return [];
      }
    }

    Future<bool> createProductCategory(ProductCategory data) async {
      final headers = await Auth.getHeaders();
      final response = await client.post(
        Uri.parse("${Config().baseUrl}/product-category"),
        headers: headers,
        body: productCategoryToJson(data)
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    Future<bool> updateProductCategory(ProductCategory data) async {
      final headers = await Auth.getHeaders();
      final response = await client.put(
        Uri.parse("${Config().baseUrl}/product-category/${data.id}"),
        headers: headers,
        body: productCategoryToJson(data)
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    Future<bool> deleteProductCategory(int id) async {
      final headers = await Auth.getHeaders();
      final response = await client.delete(
        Uri.parse("${Config().baseUrl}/product-category/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
}