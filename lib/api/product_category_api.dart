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
      print("Response body: ${response.body}"); // Testing output di sini
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
}