import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/auth/auth_model.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<void> signInUser(Auth model, BuildContext context) async {
  try {
    final response =
        await http.post(Uri.parse(Urls.signinUserUrl), body: model.toJson());
    if (response.statusCode < 300) {
      var decodedResponse = await jsonDecode(response.body);
      String token = decodedResponse['key'];
      await storeToken(token);
      Navigator.pushNamed(context, AppRoutes.homeScreen);
    } else {
      flashMessage(context, 'error', response.body.toString());
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
  }
}
