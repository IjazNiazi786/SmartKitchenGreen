import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/auth/auth_model.dart';
import 'package:smart_kitchen_green_app/presentation/auth_screens/verification/verification.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<void> registerUser(Auth model, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse(Urls.registerUserUrl),
      body: model.toJson(),
    );

    if (response.statusCode < 300) {
      await storeUserEmail(model.email!);
      flashMessage(context, 'success', response.body.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(),
          ));
    } else {
      flashMessage(context, 'error', response.body.toString());
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
  }
}
