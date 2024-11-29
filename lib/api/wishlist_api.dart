import 'package:marketplace_apps/model/wishlist_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class WishlistApi {
  final String baseUrl = 'http://127.0.0.1:8000';
  Client client = Client();

  Future<List<Wishlist>> getWishlists() async {
    final response = await client.get(Uri.parse("$baseUrl/api/wishlist"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      List<Wishlist> wishlists = data.map<Wishlist>((item) => Wishlist.fromJson(item)).toList();
      return wishlists;
    } else {
      return [];
    }
  }

  // create wishlist
  Future<bool> createWishlist(Wishlist data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/wishlist"),
      headers: {"content-type": "application/json"},
      body: wishlistToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // update wishlist
  Future<bool> updateWishlist(Wishlist data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/wishlist/${data.id}"),
      headers: {"content-type": "application/json"},
      body: wishlistToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // delete wishlist
  Future<bool> deleteWishlist(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/wishlist/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}