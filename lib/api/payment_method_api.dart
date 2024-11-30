import 'package:marketplace_apps/model/payment_method_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:marketplace_apps/util/config.dart';

class PaymentMethodApi {
  Client client = Client();

  Future<List<PaymentMethod>> getPaymentMethod() async {
    final response =
        await client.get(Uri.parse("${Config().baseUrl}/payment-method"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<PaymentMethod> paymentsMethod = data
          .map<PaymentMethod>((item) => PaymentMethod.fromJson(item))
          .toList();

      return paymentsMethod;
    } else {
      return [];
    }
  }


}
