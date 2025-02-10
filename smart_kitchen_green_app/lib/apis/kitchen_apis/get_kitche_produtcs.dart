import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<List<Product>> fetchKitchenProducts(BuildContext context) async {
  String? token = await getToken();

  try {
    var response = await http.get(
      Uri.parse(Urls.kitchenProductUrl),
      headers: {
        'Authorization': 'TOKEN $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode < 300) {
      List<Product> products = [];
      Iterable jsonResponse = json.decode(response.body);
      jsonResponse.forEach((element) {
        Product product = Product.fromJson(element);
        products.add(product);
      });

      return products;
    } else {
      flashMessage(context, 'error', response.body);
      return [];
    }
  } catch (e) {
    flashMessage(context, "error", e.toString());
    return [];
  }
}
