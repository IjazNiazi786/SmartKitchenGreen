import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<void> deleteProduct(BuildContext context, int id) async {
  String? token = await getToken();

  try {
    var response = await http.delete(
      Uri.parse('${Urls.kitchenProductUrl}$id/'),
      headers: {
        'Authorization': 'TOKEN $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode < 300) {
      flashMessage(context, "success", "SUCCESSFULLY DELETED");
    } else {
      flashMessage(context, 'error', response.body.toString());
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
  }
}
