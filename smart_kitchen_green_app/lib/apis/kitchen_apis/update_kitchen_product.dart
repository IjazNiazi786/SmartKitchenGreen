import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';
import 'package:http/http.dart' as http;

Future<void> updateKitchenProduct(BuildContext context, Product product) async {
  int id = product.id!;
  String? token = await getToken();
  String jsonData = jsonEncode(product.toJson());

  try {
    var response = await http.put(
      Uri.parse('${Urls.kitchenProductUrl}$id/'),
      body: jsonData.toString(),
      headers: {
        'Authorization': 'TOKEN $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode < 300) {
      flashMessage(context, "success", "UPDATED SUCCESSFULLY");
    } else {
      flashMessage(context, 'error', response.body.toString());
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
  }
}
