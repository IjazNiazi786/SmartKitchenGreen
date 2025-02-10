import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<void> addKitchenProducts(
    BuildContext context, List<Product> products) async {
  String? token = await getToken();

  print("TOKEN $token");
  try {
    List<String> productsData = [];
    for (var product in products) {
      productsData.add(jsonEncode(product.toJson()));
    }

    var response = await http.post(
      Uri.parse(Urls.kitchenProductUrl),
      body: productsData.toString(),
      headers: {
        'Authorization': 'TOKEN $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode < 300) {
      flashMessage(context, 'success', "DONE");
    } else {
      print("STATUS CODE ERROR ");
      print(response.body);
      flashMessage(context, 'error', response.body);
    }
  } catch (e) {
    print("CATCH E");
    flashMessage(context, 'error', e.toString());
    return;
  }
}
