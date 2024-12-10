import 'package:marketplace_apps/model/wishlist_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:marketplace_apps/util/auth.dart';
import 'package:marketplace_apps/util/config.dart';

class WishlistApi {
  Client client = Client();

  Future<List<Wishlist>> getWishlists() async {
    final headers = await Auth.getHeaders();
    final response = await client.get(Uri.parse("${Config().baseUrl}/wishlist"), headers: headers);
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