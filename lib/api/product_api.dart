import 'package:http/http.dart' show Client;
import 'package:marketplace_apps/model/product_model.dart';
import 'package:marketplace_apps/util/auth.dart';
import 'dart:convert';
import 'package:marketplace_apps/util/config.dart';
class ProductApi {
  Client client = Client();

    Future<List<Product>> getProduct() async {
      final headers = await Auth.getHeaders();
      final response = await client.get(Uri.parse("${Config().baseUrl}/product"), headers: headers);
     
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as List<dynamic>;

        // Mapping data ke model
        return data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        print("Failed to load product. Status code: ${response.statusCode}");
        return [];
      }
    }

    Future<bool> deleteProduct(int id) async {
      final headers = await Auth.getHeaders();
      final response = await client.delete(
        Uri.parse("${Config().baseUrl}/product/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
}